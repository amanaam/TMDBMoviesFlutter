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
    on<MoviesEvent>(
      (event, emit) async {
        if (event is MoviesGetMoviesEvent) {
          emit(
            MoviesLoadingState(),
          );
          await MovieUsecases().moviesGetMovieUsecase(
            event.authenticationRepository,
            movieRepository,
          );
          if (MovieUsecases().moviesLoadedUsecase(
            movieRepository,
          )) {
            MovieUsecases().moviesAddRatingsToListsUsecase(
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
          await MovieUsecases().moviesGetTopRatedMoviesUsecase(movieRepository);
        }

        if (event is MoviesReloadMoviesEvent) {
          emit(
            MoviesLoadingState(),
          );
          await MovieUsecases().moviesGetPopularMoviesUsecase(movieRepository);
          await MovieUsecases().moviesGetTopRatedMoviesUsecase(movieRepository);
          if (MovieUsecases().moviesLoadedUsecase(
            movieRepository,
          )) {
            MovieUsecases().moviesAddRatingsToListsUsecase(
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
          await MovieUsecases().moviesSearchMoviesUsecase(
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
          await MovieUsecases().moviesGetMovieDetailsUsecase(
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
          bool response = await MovieUsecases().moviesRateMovieUsecase(
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
          await MovieUsecases().moviesGetRatedMoviesUsecase(
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
