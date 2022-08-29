part of 'movies_bloc.dart';

@immutable
abstract class MoviesState {}

class MoviesInitialState extends MoviesState {}

class MoviesLoadingState extends MoviesState {}

class MoviesLoadedState extends MoviesState {
  final MovieRepository movieRepository;
  MoviesLoadedState(
    this.movieRepository,
  );
}

class MoviesLoadingFailedState extends MoviesState {}

class MoviesRatedState extends MoviesState {}

class MoviesRatingFailedState extends MoviesState {}
