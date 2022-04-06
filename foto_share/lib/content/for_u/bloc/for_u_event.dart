part of 'for_u_bloc.dart';

abstract class ForUEvent extends Equatable {
  const ForUEvent();

  @override
  List<Object> get props => [];
}

class ForUGetAllPicturesEvent extends ForUEvent {}

class ForUSetEditFieldsEvent extends ForUEvent {
  final Map<String, dynamic> data;

  ForUSetEditFieldsEvent({required this.data});

  @override
  List<Object> get props => [data];
}

class ForUShareEvent extends ForUEvent {
  final Map<String, dynamic> data;

  ForUShareEvent({required this.data});

  @override
  List<Object> get props => [data];
}
