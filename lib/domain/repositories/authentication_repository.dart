import 'package:movies/data/datasources/authenticate_data_source.dart';

class AuthenticationRepository {
  late String sessionId;
  late String userName;
  bool authenticated = false;

  Future<void> authenticateUser(username, password) async {
    sessionId = await AuthenticationImpl().authenticate(
      username: username,
      password: password,
    );
    if (sessionId != '') {
      userName = username;
      authenticated = true;
    }
  }
}
