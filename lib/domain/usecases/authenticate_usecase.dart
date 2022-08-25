import 'package:movies/domain/repositories/authentication_repository.dart';

class AuthenticateUsecase {
  Future<void> authenticateUserUsecase(
    String username,
    String password,
    AuthenticationRepository authenticationRepository,
  ) async {
    await authenticationRepository.authenticateUser(
      username,
      password,
    );
  }

  void logOutUsecase(
    AuthenticationRepository authenticationRepository,
  ) {
    authenticationRepository.sessionId = '';
    authenticationRepository.authenticated = false;
  }

  bool isLoggedInUsecase(
    AuthenticationRepository authenticationRepository,
  ) {
    return authenticationRepository.authenticated == true;
  }
}
