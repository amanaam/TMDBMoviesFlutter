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

    on<AuthenticationEvent>((event, emit) async {
      if (event is AuthenticationAuthenticateEvent) {
        emit(
          AuthenticationLoadingState(),
        );
        if (!AuthenticateUsecase()
            .isLoggedInUsecase(authenticationRepository)) {
          await AuthenticateUsecase().authenticateUserUsecase(
            event.username,
            event.password,
            authenticationRepository,
          );
          if (AuthenticateUsecase()
              .isLoggedInUsecase(authenticationRepository)) {
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
        AuthenticateUsecase().logOutUsecase(authenticationRepository);
        emit(
          AuthenticationUnauthenticatedState(),
        );
      }
    });
  }
}
