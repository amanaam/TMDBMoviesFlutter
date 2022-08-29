part of 'movies_bloc.dart';

@immutable
abstract class MoviesEvent {}

class MoviesGetMoviesEvent extends MoviesEvent {
  final AuthenticationRepository authenticationRepository;

  MoviesGetMoviesEvent(
    this.authenticationRepository,
  );
}

class MoviesRateMovieEvent extends MoviesEvent {
  final num rating;
  final num movieID;
  final AuthenticationRepository authenticationRepository;
  MoviesRateMovieEvent(
    this.rating,
    this.movieID,
    this.authenticationRepository,
  );
}

class MoviesSearchMoviesEvent extends MoviesEvent {
  final String search;
  MoviesSearchMoviesEvent(this.search);
}

class MoviesPopularMoviesEvent extends MoviesEvent {}

class MoviesInitialEvent extends MoviesEvent {}

class MoviesLoadingEvent extends MoviesEvent {}

class MoviesTopMoviesEvent extends MoviesEvent {}

class MoviesSearchEvent extends MoviesEvent {
  final String search;
  MoviesSearchEvent(
    this.search,
  );
}

class MoviesMovieDetailsEvent extends MoviesEvent {
  final String movieId;
  MoviesMovieDetailsEvent(
    this.movieId,
  );
}
