import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movies/domain/repositories/authentication_repository.dart';
import 'package:movies/domain/repositories/movie_repository.dart';
import 'package:movies/domain/usecases/movie_usecases.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MoviesBloc() : super(MoviesInitialState()) {
    MovieRepository movieRepository = MovieRepository();
    on<MoviesEvent>(
      (event, emit) async {
        if (event is MoviesGetMoviesEvent) {
          emit(MoviesLoadingState());
          await MovieUsecases().getMovieUsecase(
            event.authenticationRepository,
            movieRepository,
          );
          if (MovieUsecases().moviesLoadedUsecase(
            movieRepository,
          )) {
            MovieUsecases().addRatingsToListsUsecase(
              movieRepository,
            );
            emit(MoviesLoadedState(
              movieRepository,
            ));
          } else {
            emit(MoviesLoadingFailedState());
          }
        }

        if (event is MoviesTopMoviesEvent) {
          await MovieUsecases().getTopRatedMoviesUsecase(movieRepository);
        }

        if (event is MoviesPopularMoviesEvent) {
          await MovieUsecases().getPopularMoviesUsecase(movieRepository);
        }

        if (event is MoviesSearchEvent) {
          emit(MoviesLoadingState());
          await MovieUsecases().searchMoviesUsecase(
            event.search,
            movieRepository,
          );
          if (movieRepository.searchMoviesList != []) {
            emit(MoviesLoadedState(movieRepository));
          } else {
            emit(MoviesLoadingFailedState());
          }
        }
        if (event is MoviesInitialEvent){
          emit(MoviesInitialState());
        }

        if (event is MoviesMovieDetailsEvent) {
          emit(MoviesLoadingState());
          await MovieUsecases().getMovieDetailsUsecase(
            event.movieId,
            movieRepository,
          );
          if (movieRepository.recommendations != []) {
            emit(MoviesLoadedState(movieRepository));
          } else {
            emit(MoviesLoadingFailedState());
          }
        }
      },
    );
  }
}
