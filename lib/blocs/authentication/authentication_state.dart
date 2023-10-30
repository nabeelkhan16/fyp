part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}


final class AuthenticationAuthenticated extends AuthenticationState {}

final class AuthenticationUnauthenticated extends AuthenticationState {}

final class AuthenticationLoading extends AuthenticationState {}

final class AuthenticationError extends AuthenticationState {
  final String message;

  AuthenticationError(this.message);
}

final class InCompleteUserProfiling extends AuthenticationState {}



final class UserProfileSavedSuccessfully extends AuthenticationState {}


