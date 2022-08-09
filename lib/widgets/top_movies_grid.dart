import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/cubit/authentication_cubit.dart';
import 'package:movies/cubit/top_movies_cubit.dart';
import 'package:movies/widgets/movie_card.dart';
import 'package:provider/src/provider.dart';

class TopMoviesGrid extends StatefulWidget {
  const TopMoviesGrid({Key? key}) : super(key: key);

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
            return GridView.count(
                childAspectRatio: 4/7,
                crossAxisCount: 2,
                children: context
                    .read<TopMoviesCubit>()
                    .topMovies
                    .topMoviesList
                    .map<Widget>((movie) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: MovieCard(
                        genre: '',
                        title: movie['title'],
                        image: 'https://image.tmdb.org/t/p/w200' +
                            movie['poster_path'],
                        year: movie['release_date'],
                        id: movie['id']),
                  );
                }).toList());
          } else {
            context.read<TopMoviesCubit>().loadTopRatedMovies(
                context
                    .read<AuthenticationCubit>()
                    .userRepository);
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
