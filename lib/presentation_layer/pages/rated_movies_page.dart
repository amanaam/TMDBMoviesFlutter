import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/bloc/authentication_bloc.dart';
import 'package:movies/bloc/movies_bloc.dart';
import 'package:movies/data/models/movie_model.dart';
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
      appBar: _ratedMoviesAppBar(),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: _ratedMoviesAuthBlocBuilder,
      ),
    );
  }

  PreferredSizeWidget _ratedMoviesAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Your Rated Movies',
      ),
    );
  }

  Widget _ratedMoviesAuthBlocBuilder(
    BuildContext context,
    AuthenticationState state,
  ) {
    if (state is AuthenticationAuthenticatedState) {
      context
          .read<MoviesBloc>()
          .add(MoviesReloadRatedMoviesEvent(state.authenticationRepository));
    }
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: _ratedMoviesBlocBuilder,
    );
  }

  Widget _ratedMoviesBlocBuilder(
    BuildContext context,
    MoviesState state,
  ) {
    if (state is MoviesLoadingState) {
      return const CustomLinearProgressIndicator();
    }
    if (state is MoviesLoadedState) {
      List<MovieModel> ratedMovies = state.movieRepository.ratedMoviesList;
      return (ratedMovies.isNotEmpty)
          ? _ratedMoviesGrid(ratedMovies)
          : _textPlaceHolderWidget(NO_RATED_MOVIES_PLACEHOLDER);
    }
    if (state is MoviesLoadingFailedState) {
      return _textPlaceHolderWidget('Loading Movies Failed! Please try again!');
    }
    return Container();
  }

  Widget _ratedMoviesGrid(List<MovieModel> ratedMovies) {
    return GridView.count(
      childAspectRatio: 4 / 7,
      crossAxisCount: 2,
      children: ratedMovies.map<Widget>(
        (movie) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: MovieCard(
              movie: movie,
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _textPlaceHolderWidget(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }
}
