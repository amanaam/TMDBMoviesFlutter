part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitialState extends AuthenticationState {}

class AuthenticationAuthenticatedState extends AuthenticationState {
  final AuthenticationRepository authenticationRepository;
  AuthenticationAuthenticatedState(this.authenticationRepository);
}

class AuthenticationUnauthenticatedState extends AuthenticationState {}

class AuthenticationLoadingState extends AuthenticationState {}
