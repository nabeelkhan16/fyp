
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticateWithCredentials>((event, emit) => _mapAuthenticateWithCredentialsToState(event, emit));
    on<AuthenticationCheck>((event, emit) => _mapAuthenticationCheckToState(event, emit));
  }

  _mapAuthenticateWithCredentialsToState(event, void Function(AuthenticationState state) emit) async {
    try {
      emit(AuthenticationLoading());
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: event.email, password: event.password);
      if (userCredential.user != null) {
        emit(AuthenticationAuthenticated());
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }

  _mapAuthenticationCheckToState(AuthenticationCheck event, Emitter<AuthenticationState> emit) {
    try {
      emit(AuthenticationLoading());
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        emit(AuthenticationAuthenticated());
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }
}
