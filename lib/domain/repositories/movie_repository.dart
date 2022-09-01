import 'package:movies/data/datasources/movies_data_source.dart';
import 'package:movies/data/models/movie_model.dart';
import 'package:movies/domain/repositories/authentication_repository.dart';

class MovieRepository {
  late List<MovieModel> topRatedList;
  late List<MovieModel> popularList;
  late List<MovieModel> ratedMoviesList;
  List<MovieModel> searchMoviesList = [];
  late List<MovieModel> recommendations;
  late List<ReviewModel> reviews;
  late List<CastModel> cast;
  late List<CrewModel> crew;
  late List<GenreModel> movieGenres;
  late MovieModel movie;
  bool searched = false;

  Future<void> getMovies(
    AuthenticationRepository authRepository,
  ) async {
    topRatedList = await MoviesImpl().getTopRatedMovies();
    popularList = await MoviesImpl().getPopularMovies();
    ratedMoviesList = await MoviesImpl().getRatedMovies(
      authenticationRepository: authRepository,
    );
    movieGenres = await MoviesImpl().getMovieGenre();
  }

  Future<void> getRatedMovies(
    AuthenticationRepository authRepository,
  ) async {
    ratedMoviesList = await MoviesImpl().getRatedMovies(
      authenticationRepository: authRepository,
    );
  }

  Future<void> getPopularMovies() async {
    popularList = await MoviesImpl().getPopularMovies();
  }

  Future<void> getTopRatedMovies() async {
    topRatedList = await MoviesImpl().getTopRatedMovies();
  }

  Future<void> searchMovies(
    String searchStr,
  ) async {
    searchMoviesList = await MoviesImpl().getSearchMovies(
      searchString: searchStr,
    );
  }

  Future<void> getMovieDetails(
    String movieId,
  ) async {
    movie = await MoviesImpl().getMovie(
      movieId: movieId,
    );
    recommendations = await MoviesImpl().getMovieRecommendations(
      movieId: movieId,
    );
    reviews = await MoviesImpl().getMovieReviews(
      movieId: movieId,
    );
    List castCrew = await MoviesImpl().getMovieCast(
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
    return await MoviesImpl().postRateMovie(
      authenticationRepository: authenticationRepository,
      rating: rating,
      movieID: movieID,
    );
  }
}
