part of 'loading_bloc.dart';

@immutable
abstract class LoadingState extends Equatable {
  const LoadingState();
  @override
  List<Object> get props => [];
}

class LoadingInitial extends LoadingState {}

class LoadingFullState extends LoadingState {}
//Searchs for flags, text, images and time (mx)

class LoadingErrorState extends LoadingState {
  final String errorMsg;

  LoadingErrorState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
//If any error go to this state

class LoadingDisplayMediaState extends LoadingState {
  final dynamic image, sentence, time, country;
  final List<Map<String, String>> countries;

  LoadingDisplayMediaState(
      {required this.image,
      required this.sentence,
      required this.time,
      required this.country,
      required this.countries});
  @override
  List<Object> get props => [image, sentence, time, countries];
}
//Displays the flags and sentence media

class LoadingUpdateMediaState extends LoadingState {
  final List<Map<String, String>> countries;
  LoadingUpdateMediaState({required this.countries});
  @override
  List<Object> get props => [countries];
}
//Updating country, time, image and quote.

