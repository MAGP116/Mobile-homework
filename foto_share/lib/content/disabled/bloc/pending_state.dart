part of 'pending_bloc.dart';

abstract class PendingState extends Equatable {
  const PendingState();

  @override
  List<Object> get props => [];
}

class PendingInitial extends PendingState {}

class PendingSuccessState extends PendingState {
  //firebase element list from collection "fshare"
  final List<Map<String, dynamic>> myDisabledData;

  PendingSuccessState({required this.myDisabledData});

  @override
  List<Object> get props => [myDisabledData];
}

class PendingErrorState extends PendingState {}

class PendingEmptyState extends PendingState {}

class PendingLoadingState extends PendingState {}

class PendingUpdateState extends PendingState {}
