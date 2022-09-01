import 'package:movies/data/datasources/movies_data_source.dart';
import 'package:movies/domain/entities/movie_entity.dart';
import 'package:movies/domain/repositories/authentication_repository.dart';

class MovieRepository {
  late List<Movie> topRatedList;
  late List<Movie> popularList;
  late List<Movie> ratedMoviesList;
  List<Movie> searchMoviesList = [];
  late List<Movie> recommendations;
  late List<Review> reviews;
  late List<Cast> cast;
  late List<Crew> crew;
  late List<Genre> movieGenres;
  late Movie movie;
  bool searched = false;

  MoviesDataSource moviesDataSource =
      MoviesDataSourceImpl(); //use this instead of the instances to call function

  Future<void> getMyRatedMovies(
    AuthenticationRepository authRepository,
  ) async {
    ratedMoviesList = await moviesDataSource.getMyRatedMovies(
      authenticationRepository: authRepository,
    );
  }

  Future<void> getPopularMovies() async {
    popularList = await moviesDataSource.getPopularMovies();
  }

  Future<void> getGenres() async {
    movieGenres = await moviesDataSource.getMovieGenres();
  }

  Future<void> getTopRatedMovies() async {
    topRatedList = await moviesDataSource.getTopRatedMovies();
  }

  Future<void> searchMovies(
    String searchStr,
  ) async {
    searchMoviesList = await moviesDataSource.getSearchMovies(
      searchString: searchStr,
    );
  }

  Future<void> getMovieDetails(
    String movieId,
  ) async {
    movie = await moviesDataSource.getMovie(
      movieId: movieId,
    );
    recommendations = await moviesDataSource.getMovieRecommendations(
      movieId: movieId,
    );
    reviews = await moviesDataSource.getMovieReviews(
      movieId: movieId,
    );
    List castCrew = await moviesDataSource.getMovieCast(
      movieId: movieId,
    );
    cast = castCrew[0];
    crew = castCrew[1];
  }

  Future<bool> rateMovie(
    AuthenticationRepository authenticationRepository,
    num rating,
    num movieID,
  ) async {
    return await moviesDataSource.postRateMovie(
      authenticationRepository: authenticationRepository,
      rating: rating,
      movieID: movieID,
    );
  }
}
