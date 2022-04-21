import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:find_track_app/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../repositories/user_auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserAuthRepository _authRepo = UserAuthRepository();
  final UserRepository _userRepo = UserRepository();

  AuthBloc() : super(AuthInitial()) {
    on<VerifyAuthEvent>(_authVerification);
    on<SignOutEvent>(_authSignOut);
    on<GoogleAuthEvent>(_authSignInGoogle);
  }

  FutureOr<void> _authVerification(event, emit) {
    // Find if the user is authenticated
    if (_authRepo.isAuthenticated()) {
      emit(AuthSuccessState());
    } else {
      emit(AuthErrorState());
    }
  }

  FutureOr<void> _authSignOut(event, emit) async {
    //SignOut the current sesion
    await _authRepo.signOutGoogleUser();
    await _authRepo.signoutFirebaseUser();
    emit(AuthSignOutState());
  }

  FutureOr<void> _authSignInGoogle(event, emit) async {
    //SignIn with Google acount
    emit(AuthWaitingState());
    try {
      await _authRepo.signInGoogle();
      //After SignIn find if current acoount contains an entry in the database
      if (!(await _userRepo.userRegisterExist())) {
        _userRepo.createUser();
      }
      emit(AuthSuccessState());
    } catch (e) {
      emit(AuthErrorState());
    }
  }
}
