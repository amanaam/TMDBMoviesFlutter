part of 'movie_cubit.dart';

@immutable
abstract class MovieState {}

class MovieInitial extends MovieState {}

class LoadingMovie extends MovieState {}

class LoadedMovie extends MovieState {}

class LoadingMovieFailed extends MovieState {}
