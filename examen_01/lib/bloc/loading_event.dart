part of 'loading_bloc.dart';

@immutable
abstract class LoadingEvent extends Equatable {
  const LoadingEvent();

  @override
  List<Object> get props => [];
}

class LoadingSentenceEvent extends LoadingEvent {}

class LoadingUpdateEvent extends LoadingEvent {
  final Map<String, String> country;

  LoadingUpdateEvent(this.country);

  @override
  List<Object> get props => [country];
}
