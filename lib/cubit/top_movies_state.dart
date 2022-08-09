part of 'top_movies_cubit.dart';

@immutable
abstract class TopMoviesState {}

class TopMoviesInitial extends TopMoviesState {}

class LoadingTopMovies extends TopMoviesState {}

class LoadedTopMovies extends TopMoviesState {}

class LoadingTopMoviesFailed extends TopMoviesState {}
