import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_track_app/repositories/user_repository.dart';

import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

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
  }

  FutureOr<void> _toHome(
      HomePageToHomeEvent event, Emitter<HomePageState> emit) {
    emit(HomePageEmptyState());
  }

  FutureOr<void> _search(
      HomePageSearchEvent event, Emitter<HomePageState> emit) async {
    bool result = await record.hasPermission();

    if (!result) {
      return;
    }
    emit(HomePageSearchingState());

    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    await record.start(path: '$path/audio.m4a');
    await Future.delayed(Duration(seconds: 6));
    final path2 = await record.stop();
    emit(HomePageEmptyState());
  }

  FutureOr<void> _toFavorite(
      HomePageFavoritesEvent event, Emitter<HomePageState> emit) async {
    emit(HomePageLoadingState());
    emit(
        HomePageFavoritesState(data: (await _userRepo.getUserFavoriteSongs())));
  }

  FutureOr<void> _removeSong(
      HomePageRemoveSongEvent event, Emitter<HomePageState> emit) async {
    await _userRepo.removeFavoriteSong(event.song);
    emit(
        HomePageFavoritesState(data: (await _userRepo.getUserFavoriteSongs())));
  }
}
