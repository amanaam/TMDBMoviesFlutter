part of 'search_movies_cubit.dart';

@immutable
abstract class SearchMoviesState {}

class SearchMoviesInitial extends SearchMoviesState {}

class LoadedSearchMovies extends SearchMoviesState {}

class LoadingSearchMoviesFailed extends SearchMoviesState {}

class LoadingSearchMovies extends SearchMoviesState {}
