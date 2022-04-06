part of 'add_bloc.dart';

abstract class AddState extends Equatable {
  const AddState();

  @override
  List<Object> get props => [];
}

class AddInitial extends AddState {}

class AddImageTakedState extends AddState {
  final Map<String, dynamic> data;

  AddImageTakedState({required this.data});

  @override
  List<Object> get props => [data];
}

class AddErrorState extends AddState {}

class AddEmptyState extends AddState {}
