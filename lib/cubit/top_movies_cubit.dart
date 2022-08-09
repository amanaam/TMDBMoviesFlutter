import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movies/repositories/top_movies_repository.dart';
part 'top_movies_state.dart';

class TopMoviesCubit extends Cubit<TopMoviesState> {
  TopMoviesCubit() : super(TopMoviesInitial());
  TopMoviesRepository topMovies = TopMoviesRepository();

  loadTopRatedMovies(userRepository) async {
    emit(LoadingTopMovies());
    await topMovies.getTopRatedMovies(userRepository: userRepository);
    if (topMovies.topMoviesList != []) {
      emit(LoadedTopMovies());
    } else {
      emit(LoadingTopMoviesFailed());
    }
  }
}
