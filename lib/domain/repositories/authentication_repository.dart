import 'package:movies/data/datasources/authenticate_data_source.dart';

class AuthenticationRepository {
  late String sessionId;
  late String userName;
  bool authenticated = false;

  AuthenticationImpl authenticationImpl = AuthenticationImpl();

  Future<void> authenticateUser(username, password) async {
    sessionId = await authenticationImpl.authenticate(
      username: username,
      password: password,
    );
    if (sessionId != '') {
      userName = username;
      authenticated = true;
    }
  }
}
