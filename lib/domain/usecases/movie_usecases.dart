import 'package:movies/domain/repositories/authentication_repository.dart';
import 'package:movies/domain/repositories/movie_repository.dart';

abstract class MoviesUsecase {}

class MoviesGetMoviesUsecase extends MoviesUsecase {
  Future<void> call(
    //multiple calls should be placed here
    AuthenticationRepository authenticationRepository,
    MovieRepository movieRepository,
  ) async {
    await movieRepository.getMyRatedMovies(
      authenticationRepository,
    );
    await movieRepository.getPopularMovies();
    await movieRepository.getTopRatedMovies();
    await movieRepository.getGenres();
  }
}

class MoviesGetPopularMoviesUsecase extends MoviesUsecase {
  Future<void> call(
    MovieRepository movieRepository,
  ) async {
    await movieRepository.getPopularMovies();
  }
}

class MoviesGetMyRatedMoviesUsecase extends MoviesUsecase {
  Future<void> call(
    MovieRepository movieRepository,
    AuthenticationRepository authenticationRepository,
  ) async {
    await movieRepository.getMyRatedMovies(
      authenticationRepository,
    );
  }
}

class MoviesGetTopRatedMoviesUsecase extends MoviesUsecase {
  Future<void> call(
    MovieRepository movieRepository,
  ) async {
    await movieRepository.getTopRatedMovies();
  }
}

class MoviesLoadedUsecase extends MoviesUsecase {
  bool call(
    MovieRepository movieRepository,
  ) {
    if (movieRepository.ratedMoviesList.isNotEmpty &&
        movieRepository.popularList.isNotEmpty &&
        movieRepository.topRatedList.isNotEmpty) {
      return true;
    }
    return false;
  }
}

class MoviesAddRatingsToListsUsecase extends MoviesUsecase {
  void call(
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
}

class MoviesSearchMoviesUsecase extends MoviesUsecase {
  Future<void> call(
    String searchStr,
    MovieRepository movieRepository,
  ) async {
    await movieRepository.searchMovies(
      searchStr,
    );
  }
}

class MoviesGetMovieDetailsUsecase extends MoviesUsecase {
  Future<void> call(
    String movieId,
    MovieRepository movieRepository,
  ) async {
    await movieRepository.getMovieDetails(
      movieId,
    );
  }
}

class MoviesRateMovieUsecase extends MoviesUsecase {
  Future<bool> call(
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
