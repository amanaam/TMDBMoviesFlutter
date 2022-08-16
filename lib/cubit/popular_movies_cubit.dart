import 'package:bloc/bloc.dart';
import 'package:movies/cubit/popular_movies_state.dart';
import 'package:movies/repositories/popular_movies_repository.dart';
import 'package:movies/repositories/rated_movies_repository.dart';

class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  PopularMoviesCubit() : super(PopularMoviesInitial());
  PopularMoviesRepository popularMovies = PopularMoviesRepository();

  loadPopularMovies(RatedMoviesRepository ratedMovies) async {
    emit(LoadingPopularMovies());
    await popularMovies.getPopularMovies();
    if (popularMovies.popularMoviesList != []) {
      if (ratedMovies.ratedMoviesList != []) {
        for (var i = 0; i < popularMovies.popularMoviesList.length; i++) {
          for (var j = 0; j < ratedMovies.ratedMoviesList.length; j++) {
            if (popularMovies.popularMoviesList[i]['id'] ==
                ratedMovies.ratedMoviesList[j]['id']) {
              popularMovies.popularMoviesList[i]["rating"] =
                  ratedMovies.ratedMoviesList[j]['rating'];
            }
          }
        }
      }
      emit(LoadedPopularMovies());
    } else {
      emit(LoadingPopularMoviesFailed());
    }
  }

  refresh() {
    popularMovies.popularMoviesList = [];
    emit(PopularMoviesInitial());
  }
}
