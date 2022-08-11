import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movies/repositories/rated_movies_repository.dart';

part 'rated_movies_state.dart';

class RatedMoviesCubit extends Cubit<RatedMoviesState> {
  RatedMoviesCubit() : super(RatedMoviesInitial());
  RatedMoviesRepository ratedMovies = RatedMoviesRepository();

  loadRatedMovies(userRepository) async {
    emit(LoadingRatedMovies());
    await ratedMovies.getRatedMovies(userRepository: userRepository);
    if (ratedMovies.ratedMoviesList != []) {
      emit(LoadedRatedMovies());
    } else {
      emit(LoadingRatedMoviesFailed());
    }
  }

  refreshPage() async {
    emit(RatedMoviesInitial());
  }

  rateMovie(userRepository, movieID, rating) async {
    emit(RatingMovie());
    var response = await ratedMovies.postRateMovie(
        userRepository: userRepository, rating: rating, movieID: movieID);
    if (response) {
      emit(RatedMovie());
    } else {
      emit(RateMovieFailed());
    }
  }
}
