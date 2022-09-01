import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movies/domain/repositories/authentication_repository.dart';
import 'package:movies/domain/usecases/authenticate_usecase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc()
      : super(
          AuthenticationInitialState(),
        ) {
    AuthenticationRepository authenticationRepository =
        AuthenticationRepository();
    AuthenticateUserUsecase authenticateUserUsecase = AuthenticateUserUsecase();
    AuthenticateIsLoggedInUsecase authenticateIsLoggedInUsecase =
        AuthenticateIsLoggedInUsecase();
    AuthenticateLogOutUsecase authenticateLogOutUsecase =
        AuthenticateLogOutUsecase();

    on<AuthenticationEvent>((event, emit) async {
      if (event is AuthenticationAuthenticateEvent) {
        emit(
          AuthenticationLoadingState(),
        );
        if (!authenticateIsLoggedInUsecase.call(authenticationRepository)) {
          await authenticateUserUsecase.call(
            event.username,
            event.password,
            authenticationRepository,
          );
          if (authenticateIsLoggedInUsecase.call(authenticationRepository)) {
            emit(
              AuthenticationAuthenticatedState(authenticationRepository),
            );
          } else {
            emit(
              AuthenticationUnauthenticatedState(),
            );
          }
        } else {
          emit(
            AuthenticationAuthenticatedState(authenticationRepository),
          );
        }
      }

      if (event is AuthenticationLogoutEvent) {
        authenticateLogOutUsecase.call(authenticationRepository);
        emit(
          AuthenticationUnauthenticatedState(),
        );
      }
    });
  }
}
