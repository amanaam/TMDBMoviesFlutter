import 'package:bloc/bloc.dart';
import 'package:movies/repositories/user_repository.dart';
import 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  UserRepository userRepository = UserRepository();
  AuthenticationCubit() : super(AuthenticationUninitialized());

  authenticate(String username, String password) async {
    print(userRepository.sessionid);
    if (await userRepository.hasToken() == false) {
      emit(AuthenticationLoading());
      var sessionId = await userRepository.authenticate(
          username: username, password: password);
      // ignore: unrelated_type_equality_checks
      print(sessionId);
      if (sessionId != "") {
        emit(AuthenticationAuthenticated());
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } else {
      emit(AuthenticationAuthenticated());
    }
  }

  logout() {
    userRepository.deleteToken();
    emit(AuthenticationUnauthenticated());
  }
}
