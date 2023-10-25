part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {}

class AuthenticateWithCredentials extends AuthenticationEvent {
  final String email;
  final String password;

  AuthenticateWithCredentials(this.email, this.password);
}


 

class AuthenticationInProcess extends AuthenticationEvent {}

class AuthenticationLogout extends AuthenticationEvent {}

class AuthenticationCheck extends AuthenticationEvent {}