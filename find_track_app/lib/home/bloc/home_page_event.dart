part of 'home_page_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

class HomePageSearchEvent extends HomePageEvent {}

class HomePageToHomeEvent extends HomePageEvent {}

class HomePageFavoritesEvent extends HomePageEvent {}

class HomePageRemoveSongEvent extends HomePageEvent {
  final String song;

  HomePageRemoveSongEvent(this.song);

  @override
  List<Object> get props => [song];
}
