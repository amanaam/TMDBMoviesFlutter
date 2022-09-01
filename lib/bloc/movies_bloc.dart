import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movies/domain/repositories/authentication_repository.dart';
import 'package:movies/domain/repositories/movie_repository.dart';
import 'package:movies/domain/usecases/movie_usecases.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MoviesBloc()
      : super(
          MoviesInitialState(),
        ) {
    MovieRepository movieRepository = MovieRepository();
    MoviesGetMoviesUsecase moviesGetMoviesUsecase = MoviesGetMoviesUsecase();
    MoviesLoadedUsecase moviesLoadedUsecase = MoviesLoadedUsecase();
    MoviesAddRatingsToListsUsecase moviesAddRatingsToListsUsecase =
        MoviesAddRatingsToListsUsecase();
    MoviesGetTopRatedMoviesUsecase moviesGetTopRatedMoviesUsecase =
        MoviesGetTopRatedMoviesUsecase();
    MoviesGetPopularMoviesUsecase moviesGetPopularMoviesUsecase =
        MoviesGetPopularMoviesUsecase();
    MoviesSearchMoviesUsecase moviesSearchMoviesUsecase =
        MoviesSearchMoviesUsecase();
    MoviesGetMovieDetailsUsecase moviesGetMovieDetailsUsecase =
        MoviesGetMovieDetailsUsecase();
    MoviesRateMovieUsecase moviesRateMovieUsecase = MoviesRateMovieUsecase();
    MoviesGetMyRatedMoviesUsecase moviesGetMyRatedMoviesUsecase =
        MoviesGetMyRatedMoviesUsecase();
    on<MoviesEvent>(
      (event, emit) async {
        if (event is MoviesGetMoviesEvent) {
          emit(
            MoviesLoadingState(),
          );
          await moviesGetMoviesUsecase.call(
            event.authenticationRepository,
            movieRepository,
          );
          if (moviesLoadedUsecase.call(
            movieRepository,
          )) {
            moviesAddRatingsToListsUsecase.call(
              movieRepository,
            );
            emit(MoviesLoadedState(
              movieRepository,
            ));
          } else {
            emit(
              MoviesLoadingFailedState(),
            );
          }
        }

        if (event is MoviesTopMoviesEvent) {
          await moviesGetTopRatedMoviesUsecase.call(movieRepository);
        }

        if (event is MoviesReloadMoviesEvent) {
          emit(
            MoviesLoadingState(),
          );
          await moviesGetPopularMoviesUsecase.call(movieRepository);
          await moviesGetTopRatedMoviesUsecase.call(movieRepository);
          if (moviesLoadedUsecase.call(
            movieRepository,
          )) {
            moviesAddRatingsToListsUsecase.call(
              movieRepository,
            );
            emit(MoviesLoadedState(
              movieRepository,
            ));
          } else {
            emit(
              MoviesLoadingFailedState(),
            );
          }
        }

        if (event is MoviesSearchEvent) {
          emit(
            MoviesLoadingState(),
          );
          await moviesSearchMoviesUsecase.call(
            event.search,
            movieRepository,
          );
          if (movieRepository.searchMoviesList.isNotEmpty) {
            emit(
              MoviesLoadedState(movieRepository),
            );
          } else {
            emit(
              MoviesLoadingFailedState(),
            );
          }
        }
        if (event is MoviesInitialEvent) {
          emit(
            MoviesInitialState(),
          );
        }

        if (event is MoviesMovieDetailsEvent) {
          emit(
            MoviesLoadingState(),
          );
          await moviesGetMovieDetailsUsecase.call(
            event.movieId,
            movieRepository,
          );
          if (movieRepository.recommendations != []) {
            emit(
              MoviesLoadedState(movieRepository),
            );
          } else {
            emit(
              MoviesLoadingFailedState(),
            );
          }
        }
        if (event is MoviesRateMovieEvent) {
          bool response = await moviesRateMovieUsecase.call(
            event.rating,
            event.movieID,
            event.authenticationRepository,
            movieRepository,
          );
          if (response) {
            emit(
              MoviesRatedState(),
            );
            emit(
              MoviesLoadedState(movieRepository),
            );
          }
          if (!response) {
            emit(
              MoviesRatingFailedState(),
            );
            emit(
              MoviesLoadedState(
                movieRepository,
              ),
            );
          }
        }
        if (event is MoviesReloadRatedMoviesEvent) {
          emit(
            MoviesLoadingState(),
          );
          await moviesGetMyRatedMoviesUsecase.call(
              movieRepository, event.authenticationRepository);
          if (movieRepository.ratedMoviesList.isNotEmpty) {
            emit(
              MoviesLoadedState(movieRepository),
            );
          } else {
            emit(
              MoviesLoadingFailedState(),
            );
          }
        }
      },
    );
  }
}
