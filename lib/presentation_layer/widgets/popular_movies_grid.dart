import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/bloc/movies_bloc.dart';
import 'package:movies/presentation_layer/widgets/linear_progress_indicator_widget.dart';
import 'package:movies/presentation_layer/widgets/movie_card.dart';

class PopularMoviesGrid extends StatefulWidget {
  const PopularMoviesGrid({Key? key, required this.genres}) : super(key: key);
  final List genres;

  @override
  State<StatefulWidget> createState() => _PopularMoviesGridState();
}

class _PopularMoviesGridState extends State<PopularMoviesGrid> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(builder: (context, state) {
      if (state is MoviesLoadingState) {
        return const CustomLinearProgressIndicator();
      } else if (state is MoviesLoadedState) {
        List filteredMovies = state.movieRepository.popularList;
        // .map((movie) {
        //   final setA = movie.genres.toSet();
        //   final genreIDs = widget.genres.map((e) => e.id).toList().toSet();
        //   if (genreIDs.isNotEmpty &&
        //       setA.intersection(genreIDs).toList().length > 0) {
        //     return movie;
        //   } else if (genreIDs.isEmpty) {
        //     return movie;
        //   }
        // })
        // .whereNotNull()
        // .toList();
        if (filteredMovies.isEmpty) {
          return const Center(
              child: Text('No movies based on the selected filter'));
        } else {
          return GridView.count(
              childAspectRatio: 4 / 7,
              crossAxisCount: 2,
              children: filteredMovies.map<Widget>((movie) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: MovieCard(
                    movie: movie,
                  ),
                );
              }).toList());
        }
      } else {
        // context
        //     .read<PopularMoviesCubit>()
        //     .loadPopularMovies(context.read<RatedMoviesCubit>().ratedMovies);
        return const CustomLinearProgressIndicator();
      }
    });
  }
}
