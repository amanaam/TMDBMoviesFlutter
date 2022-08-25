import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/cubit/popular_movies_cubit.dart';
import 'package:movies/cubit/popular_movies_state.dart';
import 'package:movies/cubit/rated_movies_cubit.dart';
import 'package:movies/presentation_layer/widgets/linear_progress_indicator_widget.dart';
import 'package:movies/presentation_layer/widgets/movie_card.dart';
import 'package:movies/repositories/user_repository.dart';

class PopularMoviesGrid extends StatefulWidget {
  const PopularMoviesGrid({Key? key, required this.genres}) : super(key: key);
  final List<Genre> genres;

  @override
  State<StatefulWidget> createState() => _PopularMoviesGridState();
}

class _PopularMoviesGridState extends State<PopularMoviesGrid> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PopularMoviesCubit, PopularMoviesState>(
        builder: (context, state) {
      if (state is LoadingPopularMovies) {
        debugPrint(widget.genres.toString());
        return const CustomLinearProgressIndicator();
      } else if (state is LoadedPopularMovies) {
        List filteredMovies = context
            .read<PopularMoviesCubit>()
            .popularMovies
            .popularMoviesList
            .map((movie) {
              final setA = movie['genre_ids'].toSet();
              final genreIDs = widget.genres.map((e) => e.id).toList().toSet();
              if (genreIDs.isNotEmpty &&
                  setA.intersection(genreIDs).toList().length > 0) {
                return movie;
              } else if (genreIDs.isEmpty) {
                return movie;
              }
            })
            .whereNotNull()
            .toList();
        if (filteredMovies.isEmpty) {
          return const Center(
              child: Text('No movies based on the selected filter'));
        } else {
          return RefreshIndicator(
            onRefresh: () {
              return context.read<PopularMoviesCubit>().refresh();
            },
            child: GridView.count(
                childAspectRatio: 4 / 7,
                crossAxisCount: 2,
                children: filteredMovies.map<Widget>((movie) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: MovieCard(
                      genre: '',
                      title: movie['title'],
                      image: 'https://image.tmdb.org/t/p/w200' +
                          movie['poster_path'],
                      year: movie['release_date'],
                      id: movie['id'],
                      rating: movie['rating'] ?? movie['vote_average'] ?? 0.0,
                    ),
                  );
                }).toList()),
          );
        }
      } else {
        context
            .read<PopularMoviesCubit>()
            .loadPopularMovies(context.read<RatedMoviesCubit>().ratedMovies);
        return const CustomLinearProgressIndicator();
      }
    });
  }
}
