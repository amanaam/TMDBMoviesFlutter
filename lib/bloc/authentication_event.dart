part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AuthenticationAuthenticateEvent extends AuthenticationEvent {
  final String username;
  final String password;

  AuthenticationAuthenticateEvent(
    this.username,
    this.password,
  );
}

class AuthenticationLogoutEvent extends AuthenticationEvent {
  AuthenticationLogoutEvent();
}
