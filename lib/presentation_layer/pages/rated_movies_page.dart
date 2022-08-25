import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/cubit/rated_movies_cubit.dart';
import 'package:movies/presentation_layer/utils/constants.dart';
import 'package:movies/presentation_layer/widgets/linear_progress_indicator_widget.dart';
import 'package:movies/presentation_layer/widgets/movie_card.dart';

class RatedMoviesGrid extends StatefulWidget {
  const RatedMoviesGrid({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RatedMoviesGridState();
}

class _RatedMoviesGridState extends State<RatedMoviesGrid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<RatedMoviesCubit, RatedMoviesState>(
          builder: (context, state) {
        if (state is LoadingRatedMovies) {
          return const CustomLinearProgressIndicator();
        } else if (state is LoadedRatedMovies) {
          var ratedMovies =
              context.read<RatedMoviesCubit>().ratedMovies.ratedMoviesList;
          return (ratedMovies.isNotEmpty)
              ? GridView.count(
                  childAspectRatio: 4 / 7,
                  crossAxisCount: 2,
                  children: ratedMovies.map<Widget>((movie) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: MovieCard(
                        genre: '',
                        title: movie['title'],
                        image: 'https://image.tmdb.org/t/p/w200' +
                            movie['poster_path'],
                        year: movie['release_date'],
                        id: movie['id'],
                        rating: movie['rating'] ?? 0,
                      ),
                    );
                  }).toList())
              : const Center(
                  child: Text(
                  NO_RATED_MOVIES_PLACEHOLDER,
                  style: TextStyle(fontSize: 17),
                ));
        } else {
          // context.read<RatedMoviesCubit>().loadRatedMovies(
          //     context.read<AuthenticationCubit>().userRepository);
          return const CustomLinearProgressIndicator();
        }
      }),
    );
  }
}
