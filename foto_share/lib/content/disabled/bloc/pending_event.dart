part of 'pending_bloc.dart';

abstract class PendingEvent extends Equatable {
  const PendingEvent();

  @override
  List<Object> get props => [];
}

class GetAllDisabledPicturesEvent extends PendingEvent {}

class PendingEnablePictureEvent extends PendingEvent {
  final String id;

  PendingEnablePictureEvent(this.id);

  @override
  List<Object> get props => [id];
}
