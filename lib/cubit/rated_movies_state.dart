part of 'rated_movies_cubit.dart';

@immutable
abstract class RatedMoviesState {}

class RatedMoviesInitial extends RatedMoviesState {}

class LoadingRatedMovies extends RatedMoviesState {}

class LoadedRatedMovies extends RatedMoviesState {}

class LoadingRatedMoviesFailed extends RatedMoviesState {}

class RatedMovie extends RatedMoviesState {}

class RateMovieFailed extends RatedMoviesState {}

class RatingMovie extends RatedMoviesState {}
