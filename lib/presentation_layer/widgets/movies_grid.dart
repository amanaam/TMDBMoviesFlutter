import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/bloc/authentication_bloc.dart';
import 'package:movies/bloc/movies_bloc.dart';
import 'package:movies/data/models/movie_model.dart';
import 'package:movies/presentation_layer/utils/constants.dart';
import 'package:movies/presentation_layer/widgets/linear_progress_indicator_widget.dart';
import 'package:movies/presentation_layer/widgets/movie_card.dart';

class MoviesGrid extends StatefulWidget {
  const MoviesGrid({
    Key? key,
    required this.genres,
    required this.movies,
  }) : super(key: key);
  final List<GenreModel> genres;
  final List<MovieModel> movies;

  @override
  State<StatefulWidget> createState() => _MoviesGridState();
}

class _MoviesGridState extends State<MoviesGrid> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: _blocBuilder,
    );
  }

  Widget _blocBuilder(
    BuildContext context,
    MoviesState state,
  ) {
    if (state is MoviesLoadingState) {
      return const CustomLinearProgressIndicator();
    } else if (state is MoviesLoadedState) {
      List<MovieModel> filteredMovies = widget.movies
          .map(
            (movie) {
              final setA = movie.genres.toSet();
              final genreIDs = widget.genres.map((e) => e.id).toList().toSet();
              if (genreIDs.isNotEmpty &&
                  setA.intersection(genreIDs).toList().isNotEmpty) {
                return movie;
              } else if (genreIDs.isEmpty) {
                return movie;
              }
            },
          )
          .whereNotNull()
          .toList();
      if (filteredMovies.isEmpty) {
        return const Center(
          child: Text(
            'No movies based on the selected filter',
          ),
        );
      } else {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () {
                if (state is AuthenticationAuthenticatedState) {
                  context.read<MoviesBloc>().add(
                        MoviesGetMoviesEvent(
                          state.authenticationRepository,
                        ),
                      );
                }
                return Future(() => false);
              },
              child: _moviesGrid(
                filteredMovies,
              ),
            );
          },
        );
      }
    } else {
      return const CustomLinearProgressIndicator();
    }
  }

  Widget _moviesGrid(
    List<MovieModel> movies,
  ) {
    return GridView.count(
      childAspectRatio: 4 / 7,
      crossAxisCount: 2,
      children: movies.map<Widget>(
        (movie) {
          return Padding(
            padding: const EdgeInsets.all(
              PADDING_NORMAL,
            ),
            child: MovieCard(
              movie: movie,
            ),
          );
        },
      ).toList(),
    );
  }
}
