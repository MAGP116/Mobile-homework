part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthSuccessState extends AuthState {}

class AuthErrorState extends AuthState {}

class AuthWaitingState extends AuthState {}

class AuthSignOutState extends AuthState {}
