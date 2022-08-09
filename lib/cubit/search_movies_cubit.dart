import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movies/repositories/search_movies_repository.dart';
part 'search_movies_state.dart';

class SearchMoviesCubit extends Cubit<SearchMoviesState> {
  SearchMoviesCubit() : super(SearchMoviesInitial());
  SearchMoviesRepository searchMovies = SearchMoviesRepository();

  loadSearchMovies(userRepository, searchString) async {
    emit(LoadingSearchMovies());
    await searchMovies.getSearchMovies(searchString: searchString);
    if (searchMovies.searchMoviesList != []) {
      emit(LoadedSearchMovies());
    } else {
      emit(LoadingSearchMoviesFailed());
    }
  }
}
