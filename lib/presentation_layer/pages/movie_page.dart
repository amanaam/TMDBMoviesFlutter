import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movies/bloc/authentication_bloc.dart';
import 'package:movies/bloc/movies_bloc.dart';
import 'package:movies/data/models/movie_model.dart';
import 'package:movies/presentation_layer/utils/constants.dart';
import 'package:movies/presentation_layer/utils/size_config.dart';
import 'package:movies/presentation_layer/widgets/linear_progress_indicator_widget.dart';
import 'package:movies/presentation_layer/widgets/review_card.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/movie_card.dart';

class MoviePage extends StatefulWidget {
  final MovieModel movie;

  const MoviePage({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  Widget build(BuildContext context) {
    late MoviesState moviePageState;
    return BlocProvider(
      create: (context) => MoviesBloc(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0x44000000),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocListener<MoviesBloc, MoviesState>(
          listener: (context, state) {
            if (state is MoviesRatedState) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(RATED_MOVIE_SUCCESSFUL)));
              // context.read<RatedMoviesCubit>().loadRatedMovies(
              //     context.read<AuthenticationCubit>().userRepository);
            } else if (state is MoviesRatingFailedState) {
              //
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(RATED_MOVIE_FAILED)));
              // context.read<RatedMoviesCubit>().loadRatedMovies(
              //     context.read<AuthenticationCubit>().userRepository);
            } else {
              moviePageState = state;
            }
          },
          child: BlocBuilder<MoviesBloc, MoviesState>(
            builder: _moviesBlocBuilder,
          ),
        ),
      ),
    );
  }

  Widget _moviesBlocBuilder(
    BuildContext context,
    MoviesState state,
  ) {
    BuildContext moviePageContext = context;
    if (state is MoviesLoadingState) {
      // context.read<Mo>().loadMovie(widget.movie.id);
      return const CustomLinearProgressIndicator();
    } else if (state is MoviesLoadedState) {
      MovieModel movie = state.movieRepository.movie;
      List<CastModel> movieCast = state.movieRepository.cast;
      List<CrewModel> movieCrew = state.movieRepository.crew
          .where(
            (i) => i.job == 'Director',
          )
          .toList();
      List<MovieModel> movieRecommendations =
          state.movieRepository.recommendations;
      List<ReviewModel> movieReviews = state.movieRepository.reviews;
      return ListView(
        padding: const EdgeInsets.only(
          top: 0,
        ),
        children: [
          _renderImage(movie),
          Container(
            width: SizeConfig.screenWidth,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _renderTitle(movie),
                _renderReleaseDate(movie),
                _renderOverview(movie),
                _renderGenre(movie),
                _renderRunTime(movie),
                _renderVotingAverage(movie),
                _renderCast(movieCast),
                _renderCrew(movieCrew),
                _renderProductionCompanies(movie),
                _renderButtons(movie),
                _renderRating(movie, moviePageContext),
                _renderReviews(movieReviews),
                _renderRecommendations(movieRecommendations),
              ],
            ),
          )
        ],
      );
    }
    if (state is MoviesRatedState || state is MoviesRatingFailedState) {
      return CustomLinearProgressIndicator();
    } else {
      context
          .read<MoviesBloc>()
          .add(MoviesMovieDetailsEvent(widget.movie.id.toString()));
      return const CustomLinearProgressIndicator();
    }
  }

  Widget _renderImage(
    MovieModel movie,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Image.network(
        movie.posterPathHD,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _renderTitle(
    MovieModel movie,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Text(
        movie.title,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
        maxLines: 2,
      ),
    );
  }

  Widget _renderReleaseDate(
    MovieModel movie,
  ) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Text(
        movie.releaseDate,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 15,
        ),
        maxLines: 2,
      ),
    );
  }

  Widget _renderOverview(
    MovieModel movie,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Text(
        movie.overview,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _renderRunTime(
    MovieModel movie,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: Text(
          'Runtime: ${movie.runtime.toString()} minutes',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _renderVotingAverage(
    MovieModel movie,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 10.0,
        ),
        child: Text(
          'Rating: ${movie.voteAverage.toString()}',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _renderCast(
    List<CastModel> movieCast,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          0,
          0,
          0,
          10,
        ),
        child: Text(
          'Cast: ${movieCast.map((cast) {
            return cast.name;
          })}'
              .replaceAll('(', '')
              .replaceAll(')', ''),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _renderProductionCompanies(
    MovieModel movie,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          0,
          0,
          0,
          10,
        ),
        child: Text(
          'Production Studios: ${movie.productionCompanies.map((cast) {
            return cast ?? '';
          })}'
              .replaceAll('(', '')
              .replaceAll(')', ''),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _renderCrew(
    List<CrewModel> movieCrew,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          0,
          0,
          0,
          10,
        ),
        child: Text(
          'Directors: ${movieCrew.map((directors) {
            return directors.name;
          })}'
              .replaceAll('(', '')
              .replaceAll(')', ''),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _renderButtons(
    MovieModel movie,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          child: ButtonTheme(
            minWidth: SizeConfig.screenWidth / 4,
            height: 40,
            buttonColor: Colors.green,
            child: RaisedButton(
              elevation: 5,
              onPressed: () {
                launch(movie.homepage);
              },
              child: const InkWell(
                child: Text(
                  'Homepage',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          child: ButtonTheme(
            minWidth: SizeConfig.screenWidth / 4,
            height: 40,
            buttonColor: Colors.green,
            child: RaisedButton(
              elevation: 5,
              onPressed: () {
                launch('https://www.imdb.com/title/${movie.imdbId}');
              },
              child: const InkWell(
                child: Text(
                  'IMDB Page',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderGenre(
    MovieModel movie,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
        ),
        child: Text(
          'Genres: ${movie.genreNames.map((name) {
            return name;
          })}'
              .replaceAll('(', '')
              .replaceAll(')', ''),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _renderRating(
    MovieModel movie,
    BuildContext moviePageContext,
  ) {
    return Column(
      children: [
        SizedBox(
          width: SizeConfig.screenWidth,
          child: const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Rate',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is AuthenticationAuthenticatedState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: RatingBar.builder(
                initialRating:
                    (movie.rating != 0 ? movie.rating : movie.voteAverage) / 2,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
                itemBuilder: (context, _) => const Icon(
                  Icons.movie_filter_rounded,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  context.read<MoviesBloc>().add(MoviesRateMovieEvent(
                        rating,
                        movie.id,
                        state.authenticationRepository,
                      ));
                },
              ),
            );
          }
          return Container();
        }),
      ],
    );
  }

  Widget _renderReviews(
    List<ReviewModel> movieReviews,
  ) {
    return Column(
      children: [
        SizedBox(
          width: SizeConfig.screenWidth,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 260,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: movieReviews.length > 0
                ? movieReviews.map<Widget>(
                    (review) {
                      return ReviewCard(
                        author: review.name,
                        content: review.content,
                      );
                    },
                  ).toList()
                : [
                    const ReviewCard(
                        author: NO_REVIEW_TITLE, content: NO_REVIEW_CONTENT)
                  ],
          ),
        ),
      ],
    );
  }

  Widget _renderRecommendations(List<MovieModel> movieRecommendations) {
    return Column(
      children: [
        SizedBox(
          width: SizeConfig.screenWidth,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              RECOMMENDED_MOVIES_TITLE,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 350,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: movieRecommendations.map<Widget>(
              (movie) {
                return MovieCard(
                  movie: movie,
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}
