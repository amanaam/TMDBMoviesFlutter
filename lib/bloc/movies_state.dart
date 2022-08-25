part of 'movies_bloc.dart';

@immutable
abstract class MoviesState {}

class MoviesInitialState extends MoviesState {}

class MoviesLoadingState extends MoviesState {}

class MoviesLoadedState extends MoviesState {}

class MoviesLoadingFailedState extends MoviesState {}
