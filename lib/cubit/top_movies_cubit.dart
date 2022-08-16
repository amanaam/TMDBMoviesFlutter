import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movies/repositories/rated_movies_repository.dart';
import 'package:movies/repositories/top_movies_repository.dart';

part 'top_movies_state.dart';

class TopMoviesCubit extends Cubit<TopMoviesState> {
  TopMoviesCubit() : super(TopMoviesInitial());
  TopMoviesRepository topMovies = TopMoviesRepository();

  loadTopRatedMovies(RatedMoviesRepository ratedMovies) async {
    emit(LoadingTopMovies());
    await topMovies.getTopRatedMovies();
    if (topMovies.topMoviesList != []) {
      if (ratedMovies.ratedMoviesList != []) {
        for (var i = 0; i < topMovies.topMoviesList.length; i++) {
          for (var j = 0; j < ratedMovies.ratedMoviesList.length; j++) {
            if (topMovies.topMoviesList[i]['id'] ==
                ratedMovies.ratedMoviesList[j]['id']) {
              topMovies.topMoviesList[i]["rating"] =
                  ratedMovies.ratedMoviesList[j]['rating'];
            }
          }
        }
      }
      emit(LoadedTopMovies());
    } else {
      emit(LoadingTopMoviesFailed());
    }
  }

  refresh() {
    topMovies.topMoviesList = [];
    emit(TopMoviesInitial());
  }
}
