part of 'for_u_bloc.dart';

abstract class ForUState extends Equatable {
  const ForUState();

  @override
  List<Object> get props => [];
}

class ForUInitial extends ForUState {}

class ForULoadingState extends ForUState {}

class ForUSuccessState extends ForUState {
  final List<Map<String, dynamic>> data;

  ForUSuccessState({required this.data});
}

class ForUErrorState extends ForUState {}

class ForUEmptyState extends ForUState {}
