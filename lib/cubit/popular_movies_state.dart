import 'package:equatable/equatable.dart';

abstract class PopularMoviesState extends Equatable {
  @override
  List<Object> get props => [];
}

class PopularMoviesInitial extends PopularMoviesState {}

class LoadingPopularMovies extends PopularMoviesState {}

class LoadedPopularMovies extends PopularMoviesState {}

class LoadingPopularMoviesFailed extends PopularMoviesState {}



