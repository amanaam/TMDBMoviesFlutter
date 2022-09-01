import 'package:movies/domain/repositories/authentication_repository.dart';

abstract class AuthenticateUsecase {}

class AuthenticateUserUsecase extends AuthenticateUsecase {
  Future<void> call(
    String username,
    String password,
    AuthenticationRepository authenticationRepository,
  ) async {
    await authenticationRepository.authenticateUser(
      username,
      password,
    );
  }
}

class AuthenticateLogOutUsecase extends AuthenticateUsecase {
  void call(
    AuthenticationRepository authenticationRepository,
  ) {
    authenticationRepository.sessionId = '';
    authenticationRepository.authenticated = false;
  }
}

class AuthenticateIsLoggedInUsecase extends AuthenticateUsecase {
  bool call(
    AuthenticationRepository authenticationRepository,
  ) {
    return authenticationRepository.authenticated == true;
  }
}
