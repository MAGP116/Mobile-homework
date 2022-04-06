part of 'my_pictures_bloc.dart';

abstract class MyPicturesEvent extends Equatable {
  const MyPicturesEvent();

  @override
  List<Object> get props => [];
}

class GetAllPicturesEvent extends MyPicturesEvent {}

class EditPictureEvent extends MyPicturesEvent {
  final Map<String, dynamic> data;

  EditPictureEvent({required this.data});
  @override
  List<Object> get props => [data];
}

class TakePictureEvent extends MyPicturesEvent {
  final ImageSource source;

  TakePictureEvent({required this.source});

  @override
  List<Object> get props => [source];
}

class UpdatePictureEvent extends MyPicturesEvent {
  final Map<String, dynamic> data;

  UpdatePictureEvent({required this.data});
  @override
  List<Object> get props => [data];
}
