import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/bloc/authentication_bloc.dart';
import 'package:movies/bloc/movies_bloc.dart';
import 'package:movies/data/models/movie_model.dart';
import 'package:movies/presentation_layer/utils/constants.dart';
import 'package:movies/presentation_layer/widgets/linear_progress_indicator_widget.dart';
import 'package:movies/presentation_layer/widgets/movie_card.dart';

class RatedMoviesPage extends StatefulWidget {
  const RatedMoviesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RatedMoviesPageState();
}

class _RatedMoviesPageState extends State<RatedMoviesPage> {
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
        RATED_MOVIE_PAGE_TITLE,
      ),
    );
  }

  Widget _ratedMoviesAuthBlocBuilder(
    BuildContext context,
    AuthenticationState state,
  ) {
    if (state is AuthenticationAuthenticatedState) {
      context.read<MoviesBloc>().add(
            MoviesReloadRatedMoviesEvent(
              state.authenticationRepository,
            ),
          );
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
          ? _ratedMoviesGrid(
              ratedMovies,
            )
          : _textPlaceHolderWidget(
              NO_RATED_MOVIES_PLACEHOLDER,
            );
    }
    if (state is MoviesLoadingFailedState) {
      return _textPlaceHolderWidget(
        RATED_MOVIE_LOADING_FAILED,
      );
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

  Widget _textPlaceHolderWidget(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: FONT_SIZE_S,
        ),
      ),
    );
  }
}
