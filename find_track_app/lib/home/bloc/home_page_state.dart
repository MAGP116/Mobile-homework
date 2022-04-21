part of 'home_page_bloc.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

class HomePageInitial extends HomePageState {}

class HomePageLoadingState extends HomePageState {}

class HomePageEmptyState extends HomePageState {}

class HomePageSearchingState extends HomePageState {}

class HomePageFoundState extends HomePageState {}

class HomePageFavoritesState extends HomePageState {
  final List<Map<String, dynamic>> data;

  HomePageFavoritesState({required this.data});

  @override
  List<Object> get props => [data];
}
