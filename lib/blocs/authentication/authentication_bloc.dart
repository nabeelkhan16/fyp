import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trash_collector/models/user_model.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';


 class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  UserModel? userModel;

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationSignUp>((event, emit) => _mapAuthenticationSignUpToState(event, emit));
    on<SaveUserProfile>((event, emit) => _mapSaveUserProfileToState(event, emit));
    on<AuthenticateWithCredentials>((event, emit) => _mapAuthenticateWithCredentialsToState(event, emit));
    on<AuthenticationCheck>((event, emit) => _mapAuthenticationCheckToState(event, emit));
    on<AuthenticationLogout>((event, emit) => _mapAuthenticationLogoutToState(event, emit));
  }

  _mapAuthenticateWithCredentialsToState(event, void Function(AuthenticationState state) emit) async {
    try {
      emit(AuthenticationLoading());
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: event.email, password: event.password);
      if (userCredential.user != null) {
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get().then((value) {
          userModel = UserModel.fromMap(value.data()!);
        });

        emit(AuthenticationAuthenticated());
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }

  _mapAuthenticationCheckToState(AuthenticationCheck event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationLoading());
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((value) {
          if (value.exists) {
            userModel = UserModel.fromMap(value.data()!);
            emit(AuthenticationAuthenticated());
          } else {
            emit(InCompleteUserProfiling());
          }
        });
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }

  _mapAuthenticationSignUpToState(AuthenticationSignUp event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationLoading());
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: event.email, password: event.password);

      if (userCredential.user != null) {

        emit(InCompleteUserProfiling());
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }

  _mapSaveUserProfileToState(SaveUserProfile event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationLoading());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(event.user.toMap(), SetOptions(merge: true));
          userModel = event.user;
      
      emit(AuthenticationAuthenticated());
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }

  _mapAuthenticationLogoutToState(AuthenticationLogout event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationLoading());
      await FirebaseAuth.instance.signOut();
      emit(AuthenticationUnauthenticated());
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }
}
