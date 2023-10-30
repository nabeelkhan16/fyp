part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {}

class AuthenticateWithCredentials extends AuthenticationEvent {
  final String email;
  final String password;

  AuthenticateWithCredentials(this.email, this.password);
}

class AuthenticationSignUp extends AuthenticationEvent {
  final String email;
  final String password;

  AuthenticationSignUp(this.email, this.password);
}

class SaveUserProfile extends AuthenticationEvent {
 final UserModel user;

  SaveUserProfile( this.user);
}

class CompleteUserProfiling extends AuthenticationEvent {
  final String name;
  final String phoneNumber;
  final String address;

  CompleteUserProfiling(this.name, this.phoneNumber, this.address);
}

class AuthenticationInProcess extends AuthenticationEvent {}

class AuthenticationLogout extends AuthenticationEvent {}

class AuthenticationCheck extends AuthenticationEvent {}
