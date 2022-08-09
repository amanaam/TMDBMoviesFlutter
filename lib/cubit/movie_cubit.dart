import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movies/repositories/movie_repository.dart';

part 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  MovieCubit() : super(MovieInitial());

  MoviesRepository movie = MoviesRepository();

  loadMovie(movieId) async {
    emit(LoadingMovie());
    await movie.getMovie(movieId: movieId);
    await movie.getCast(movieId: movieId);
    await movie.getRecommendations(movieId: movieId);
    await movie.getReviews(movieId: movieId);
    if (movie.movieDetails != [] && movie.movieCast != [] &&
        movie.movieDirectors != [] && movie.movieRecommendations != [] &&
        movie.movieReviews != []) {
      emit(LoadedMovie());
    } else {
      emit(LoadingMovieFailed());
    }
  }
}
