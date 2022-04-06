import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foto_share/auth/user_auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserAuthRepository _authRepo = UserAuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<VerifyAuthEvent>(_authVerification);
    on<AnonymousAuthEvent>(_authAnonymous);
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

  FutureOr<void> _authAnonymous(event, emit) {
    // TODO: implement event handler
  }

  FutureOr<void> _authSignOut(event, emit) async {
    //SignOut the current sesion
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      //If user is anonymous
      await _authRepo.signoutFirebaseUser();
    } else {
      //If user is signed with google
      await _authRepo.signOutGoogleUser();
      await _authRepo.signoutFirebaseUser();
    }
    emit(AuthSignOutState());
  }

  FutureOr<void> _authSignInGoogle(event, emit) async {
    //SignIn with Google acount
    emit(AuthWaitingState());
    try {
      await _authRepo.signInGoogle();
      //After SignIn find if current acoount contains an entry in the database
      var docsRef = await FirebaseFirestore.instance
          .collection("userPictures")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (!docsRef.exists) {
        //If not entry was found create it
        await FirebaseFirestore.instance
            .collection("userPictures")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({"pictureIDs": []});
      }
      emit(AuthSuccessState());
    } catch (e) {
      emit(AuthErrorState());
    }
  }
}
