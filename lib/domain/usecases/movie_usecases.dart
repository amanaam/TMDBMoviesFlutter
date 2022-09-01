import 'package:movies/domain/repositories/authentication_repository.dart';
import 'package:movies/domain/repositories/movie_repository.dart';

class MovieUsecases {
  Future<void> moviesGetMovieUsecase(
    AuthenticationRepository authenticationRepository,
    MovieRepository movieRepository,
  ) async {
    await movieRepository.getMovies(
      authenticationRepository,
    );
  }

  Future<void> moviesGetPopularMoviesUsecase(
    MovieRepository movieRepository,
  ) async {
    await movieRepository.getPopularMovies();
  }

  Future<void> moviesGetRatedMoviesUsecase(
    MovieRepository movieRepository,
    AuthenticationRepository authenticationRepository,
  ) async {
    await movieRepository.getRatedMovies(
      authenticationRepository,
    );
  }

  Future<void> moviesGetTopRatedMoviesUsecase(
    MovieRepository movieRepository,
  ) async {
    await movieRepository.getTopRatedMovies();
  }

  bool moviesLoadedUsecase(
    MovieRepository movieRepository,
  ) {
    if (movieRepository.ratedMoviesList.isNotEmpty &&
        movieRepository.popularList.isNotEmpty &&
        movieRepository.topRatedList.isNotEmpty) {
      return true;
    }
    return false;
  }

  void moviesAddRatingsToListsUsecase(
    MovieRepository movieRepository,
  ) {
    for (var i = 0; i < movieRepository.ratedMoviesList.length; i++) {
      for (var j = 0; j < movieRepository.topRatedList.length; j++) {
        if (movieRepository.topRatedList[j].id ==
            movieRepository.ratedMoviesList[i].id) {
          movieRepository.topRatedList[j].rating =
              movieRepository.ratedMoviesList[i].rating;
        }
      }
      for (var j = 0; j < movieRepository.popularList.length; j++) {
        if (movieRepository.popularList[j].id ==
            movieRepository.ratedMoviesList[i].id) {
          movieRepository.popularList[j].rating =
              movieRepository.ratedMoviesList[i].rating;
        }
      }
    }
  }

  Future<void> moviesSearchMoviesUsecase(
    String searchStr,
    MovieRepository movieRepository,
  ) async {
    await movieRepository.searchMovies(
      searchStr,
    );
  }

  Future<void> moviesGetMovieDetailsUsecase(
    String movieId,
    MovieRepository movieRepository,
  ) async {
    await movieRepository.getMovieDetails(
      movieId,
    );
  }

  Future<bool> moviesRateMovieUsecase(
    num rating,
    num movieID,
    AuthenticationRepository authenticationRepository,
    MovieRepository movieRepository,
  ) async {
    return await movieRepository.rateMovie(
      authenticationRepository,
      rating,
      movieID,
    );
  }
}
