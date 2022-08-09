import 'package:bloc/bloc.dart';
import 'package:movies/repositories/popular_movies_repository.dart';
import 'package:movies/cubit/popular_movies_state.dart';

class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  PopularMoviesCubit() : super(PopularMoviesInitial());
  PopularMoviesRepository popularMovies = PopularMoviesRepository();

  loadPopularMovies(userRepository) async {
    emit(LoadingPopularMovies());
    await popularMovies.getPopularMovies(userRepository: userRepository);
    if (popularMovies.popularMoviesList != []) {
      emit(LoadedPopularMovies());
    } else {
      emit(LoadingPopularMoviesFailed());
    }
  }
}
