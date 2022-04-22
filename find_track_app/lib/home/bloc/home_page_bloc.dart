import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_track_app/repositories/user_repository.dart';
import 'package:find_track_app/secrets/secrets.dart';

import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final UserRepository _userRepo = UserRepository();
  final record = Record();
  HomePageBloc() : super(HomePageInitial()) {
    on<HomePageToHomeEvent>(_toHome);
    on<HomePageSearchEvent>(_search);
    on<HomePageFavoritesEvent>(_toFavorite);
    on<HomePageRemoveSongEvent>(_removeSong);
    on<HomePageAddSongEvent>(_addSong);
  }

  FutureOr<void> _toHome(
      HomePageToHomeEvent event, Emitter<HomePageState> emit) {
    emit(HomePageEmptyState());
  }

  FutureOr<void> _search(
      HomePageSearchEvent event, Emitter<HomePageState> emit) async {
    bool result = await record.hasPermission();

    if (!result || await record.isRecording()) {
      return;
    }
    emit(HomePageSearchingState());

    try {
      final directory = await getApplicationDocumentsDirectory();
      var path = directory.path;
      await record.start(path: '$path/audio.m4a');
      await Future.delayed(Duration(seconds: 6));
      final path2 = await record.stop();
      final bytes = base64Encode(File(path2!).readAsBytesSync());
      var request = await http.post(Uri.parse('https://api.audd.io/'), body: {
        'return': 'apple_music,spotify',
        'api_token': audioToken,
        'audio': bytes
      });
      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        if (data["status"] == "success" && data["result"] != null) {
          //If the request was success and the song was found
          emit(HomePageFoundState(data: {
            'artist': data["result"]['artist'],
            'album': data["result"]['album'],
            'image_url': data['result']['spotify']['album']['images'][0]['url'],
            'title': data["result"]['title'],
            'release_date': data["result"]['release_date'],
            'spotify_url': data["result"]['spotify']['external_urls']
                ['spotify'],
            'apple_url': data["result"]['apple_music']['url'],
            'song_url': data["result"]['song_link'],
          }));
          return;
        }
        emit(HomePageErrorState('Song not found'));
      }
    } catch (e) {
      emit(HomePageErrorState(e.toString()));
    }
  }

  FutureOr<void> _toFavorite(
      HomePageFavoritesEvent event, Emitter<HomePageState> emit) async {
    emit(HomePageLoadingState());
    try {
      emit(HomePageFavoritesState(
          data: (await _userRepo.getUserFavoriteSongs())));
    } catch (e) {
      emit(HomePageErrorState(e.toString()));
    }
  }

  FutureOr<void> _removeSong(
      HomePageRemoveSongEvent event, Emitter<HomePageState> emit) async {
    try {
      await _userRepo.removeFavoriteSong(event.song);
      emit(HomePageFavoritesState(
          data: (await _userRepo.getUserFavoriteSongs())));
    } catch (e) {
      emit(HomePageErrorState(e.toString()));
    }
  }

  FutureOr<void> _addSong(
      HomePageAddSongEvent event, Emitter<HomePageState> emit) async {
    try {
      emit(HomePageMessageState('Processing...'));
      emit(HomePageFoundState(data: event.data));
      var res = await _userRepo.addFavoriteSong({
        'title': event.data['title'],
        'artist': event.data['artist'],
        'songUrl': event.data['song_url'],
        'imageUrl': event.data['image_url']
      });
      emit(HomePageMessageState(
          res ? 'Song added to favorites' : 'Song already in favorites'));
      emit(HomePageFoundState(data: event.data));
    } catch (e) {
      emit(HomePageMessageState('Something went wrong'));
      emit(HomePageFoundState(data: event.data));
    }
  }
}
