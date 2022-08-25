import 'package:movies/data/datasources/authenticate_data_source.dart';

class AuthenticationRepository {
  late String sessionId;
  bool authenticated = false;

  Future<void> authenticateUser(username, password) async {
    sessionId = await AuthenticationImpl().authenticate(
      username: username,
      password: password,
    );
    authenticated = true;
  }
}
