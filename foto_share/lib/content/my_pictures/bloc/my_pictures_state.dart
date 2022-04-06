part of 'my_pictures_bloc.dart';

abstract class MyPicturesState extends Equatable {
  const MyPicturesState();

  @override
  List<Object> get props => [];
}

class MyPicturesInitial extends MyPicturesState {}

class MyPictureEmptyState extends MyPicturesState {}

class MyPicturesLoadigState extends MyPicturesState {}

class MyPicturesReloadState extends MyPicturesState {}

class MyPicturesErrorState extends MyPicturesState {}

class MyPictureSuccessState extends MyPicturesState {
  final List<Map<String, dynamic>> myData;

  MyPictureSuccessState({required this.myData});

  @override
  List<Object> get props => [myData];
}

class MyPicturesImageTakedState extends MyPicturesState {
  final Uint8List image;

  MyPicturesImageTakedState({required this.image});
  @override
  List<Object> get props => [image];
}

class MyPictureEditState extends MyPicturesState {
  Map<String, dynamic> data;
  MyPictureEditState({required this.data});

  @override
  List<Object> get props => [data];
}
