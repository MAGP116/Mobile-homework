import 'package:bloc/bloc.dart';
import 'package:examen_01/countries.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../requests.dart';

part 'loading_event.dart';
part 'loading_state.dart';

class LoadingBloc extends Bloc<LoadingEvent, LoadingState> {
  LoadingBloc() : super(LoadingInitial()) {
    on<LoadingSentenceEvent>(_onLoadingSentence);
    on<LoadingUpdateEvent>(_onUpdating);
  }

  _onLoadingSentence(LoadingEvent event, Emitter emit) async {
    emit(LoadingFullState());
    try {
      //Temp test get flag
      for (var c in countries) {
        c["flag"] = await Requests().getFlag(c["id"]);
      }
      //Get image
      var img = await Requests().getImage();
      //GET random sentence
      var sentence = await Requests().getSentence();
      //GET time
      var time = await Requests().getTime("America/Mexico_City");
      emit(LoadingDisplayMediaState(
          countries: countries,
          image: img,
          sentence: sentence,
          country: "México",
          time: time));
    } catch (err) {
      emit(LoadingErrorState(errorMsg: "Error ${err}"));
    }
  }

  _onUpdating(LoadingUpdateEvent event, Emitter emit) async {
    emit(LoadingUpdateMediaState(countries: countries));
    try {
      //Get image
      var img = await Requests().getImage();
      //GET random sentence
      var sentence = await Requests().getSentence();
      //GET time
      var time = await Requests().getTime(event.country["time"]);
      emit(LoadingDisplayMediaState(
          countries: countries,
          image: img,
          sentence: sentence,
          country: event.country["name"],
          time: time));
    } catch (err) {
      emit(LoadingErrorState(errorMsg: "Error ${err}"));
    }
  }
}
