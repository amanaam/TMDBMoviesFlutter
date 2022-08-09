import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/cubit/authentication_cubit.dart';
import 'package:movies/cubit/popular_movies_cubit.dart';
import 'package:movies/cubit/popular_movies_state.dart';
import 'package:movies/widgets/movie_card.dart';

class PopularMoviesGrid extends StatefulWidget {
  const PopularMoviesGrid({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PopularMoviesGridState();
}

class _PopularMoviesGridState extends State<PopularMoviesGrid> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PopularMoviesCubit, PopularMoviesState>(
        builder: (context, state) {
      if (state is LoadingPopularMovies) {
        return const Center(
          child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  semanticsLabel: 'Linear progress indicator')),
        );
      } else if (state is LoadedPopularMovies) {
        return GridView.count(
            childAspectRatio: 4/7,
            crossAxisCount: 2,
            children: context
                .read<PopularMoviesCubit>()
                .popularMovies
                .popularMoviesList
                .map<Widget>((movie) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: MovieCard(
                    genre: '',
                    title: movie['title'],
                    image:
                        'https://image.tmdb.org/t/p/w200' + movie['poster_path'],
                    year: movie['release_date'],
                    id: movie['id'],),
              );
            }).toList());
      } else {
        context.read<PopularMoviesCubit>().loadPopularMovies(
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
