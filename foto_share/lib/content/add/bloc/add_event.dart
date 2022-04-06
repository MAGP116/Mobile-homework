part of 'add_bloc.dart';

abstract class AddEvent extends Equatable {
  const AddEvent();

  @override
  List<Object> get props => [];
}

class AddInitEvent extends AddEvent {}

class AddGetImageEvent extends AddEvent {
  final ImageSource source;

  AddGetImageEvent({required this.source});

  @override
  List<Object> get props => [source];
}

class AddUploadEvent extends AddEvent {
  final Map<String, dynamic> data;

  AddUploadEvent(this.data);

  @override
  List<Object> get props => [data];
}
