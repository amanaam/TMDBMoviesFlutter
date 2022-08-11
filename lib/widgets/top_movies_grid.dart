import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/cubit/authentication_cubit.dart';
import 'package:movies/cubit/top_movies_cubit.dart';
import 'package:movies/repositories/popular_movies_repository.dart';
import 'package:movies/widgets/movie_card.dart';
import 'package:provider/src/provider.dart';

class TopMoviesGrid extends StatefulWidget {
  const TopMoviesGrid({Key? key, required this.genres}) : super(key: key);
  final List<Genre> genres;
  @override
  State<StatefulWidget> createState() => _TopMoviesGridState();
}

class _TopMoviesGridState extends State<TopMoviesGrid> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopMoviesCubit, TopMoviesState>(
        builder: (context, state) {
      if (state is LoadingTopMovies) {
        return const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                semanticsLabel: 'Linear progress indicator'));
      } else if (state is LoadedTopMovies) {
        List filteredMovies = context
            .read<TopMoviesCubit>()
            .topMovies
            .topMoviesList
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
          return GridView.count(
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
                    rating: movie['vote_average'] ?? 0,
                  ),
                );
              }).toList());
        }
      } else {
        context.read<TopMoviesCubit>().loadTopRatedMovies(
            context.read<AuthenticationCubit>().userRepository);
        return const Center(
          child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  semanticsLabel: 'Linear progress indicator')),
        );
      }
    });
  }
}
