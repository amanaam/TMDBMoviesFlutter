import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movies/bloc/authentication_bloc.dart';
import 'package:movies/bloc/movies_bloc.dart';
import 'package:movies/domain/entities/movie_entity.dart';
import 'package:movies/presentation_layer/utils/constants.dart';
import 'package:movies/presentation_layer/utils/size_config.dart';
import 'package:movies/presentation_layer/widgets/custom_progress_indicator.dart';
import 'package:movies/presentation_layer/widgets/review_card.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/movie_card.dart';

class MoviePage extends StatefulWidget {
  final Movie movie;
  final callback updateRating;

  //pass entity instead of model
  //entities are relevent to ui and not the models

  const MoviePage({
    Key? key,
    required this.movie,
    required this.updateRating,
  }) : super(key: key);

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  late Movie _movie;

  @override
  void initState() {
    super.initState();
    _movie = widget.movie;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
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
        body: BlocConsumer<MoviesBloc, MoviesState>(
          listener: _blocListener,
          builder: _moviesBlocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, MoviesState state) {
    if (state is MoviesRatedState) {
      widget.updateRating.call(
        context,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            RATED_MOVIE_SUCCESSFUL,
          ),
        ),
      );
    }
    if (state is MoviesRatingFailedState) {
      //
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            RATED_MOVIE_FAILED,
          ),
        ),
      );
    }
  }

  Widget _moviesBlocBuilder(
    BuildContext context,
    MoviesState state,
  ) {
    BuildContext moviePageContext = context;
    if (state is MoviesLoadingState) {
      return const CustomLinearProgressIndicator();
    }
    if (state is MoviesLoadedState) {
      _movie = state.movieRepository.movie;
      List<Cast> movieCast = state.movieRepository.cast;
      List<Crew> movieCrew = state.movieRepository.crew
          .where(
            (Crew crew) => crew.job == 'Director',
          )
          .toList();
      List<Movie> movieRecommendations = state.movieRepository.recommendations;
      List<Review> movieReviews = state.movieRepository.reviews;
      return ListView(
        padding: const EdgeInsets.only(
          top: PADDING_NONE,
        ),
        children: [
          _renderImage(_movie),
          Container(
            width: SizeConfig.screenWidth,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, //everything will be left aligned
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    PADDING_XL,
                  ),
                  child: Column(
                    children: [
                      _renderTitle(_movie),
                      _renderReleaseDate(_movie),
                      _renderOverview(_movie),
                      _renderGenre(_movie),
                      _renderRunTime(_movie),
                      _renderVotingAverage(_movie),
                      _renderCast(movieCast),
                      _renderCrew(movieCrew),
                      _renderProductionCompanies(_movie),
                      _renderButtons(_movie),
                      _renderRating(_movie, moviePageContext),
                    ],
                  ),
                ),
                _renderReviews(movieReviews),
                _renderRecommendations(movieRecommendations),
              ],
            ),
          )
        ],
      );
    }
    if (state is MoviesRatedState || state is MoviesRatingFailedState) {
      return const CustomLinearProgressIndicator();
    }
    if (state is MoviesInitialState) {
      context.read<MoviesBloc>().add(
            MoviesMovieDetailsEvent(
              widget.movie.id.toString(),
            ),
          );
      return const CustomLinearProgressIndicator();
    } else {
      return Container();
    }
  }

  Widget _renderImage(
    Movie movie,
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
    Movie movie,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Text(
        movie.title,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: FONT_SIZE_XL,
        ),
        maxLines: 2,
      ),
    );
  }

  Widget _renderReleaseDate(
    Movie movie,
  ) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: const EdgeInsets.symmetric(
        vertical: PADDING_NORMAL,
      ),
      child: Text(
        movie.releaseDate,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: FONT_SIZE_S,
        ),
        maxLines: 2,
      ),
    );
  }

  Widget _renderOverview(
    Movie movie,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Text(
        movie.overview,
        style: const TextStyle(
          fontSize: FONT_SIZE_M,
        ),
      ),
    );
  }

  Widget _renderRunTime(
    Movie movie,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: PADDING_NORMAL,
        ),
        child: Text(
          'Runtime: ${movie.runtime.toString()} minutes',
          style: const TextStyle(
            fontSize: FONT_SIZE_M,
          ),
        ),
      ),
    );
  }

  Widget _renderVotingAverage(
    Movie movie,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: PADDING_NORMAL,
        ),
        child: Text(
          'Rating: ${movie.voteAverage.toString()}',
          style: const TextStyle(
            fontSize: FONT_SIZE_M,
          ),
        ),
      ),
    );
  }

  Widget _renderCast(
    List<Cast> movieCast,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: PADDING_NORMAL,
        ),
        child: Text(
          'Cast: ${movieCast.map((cast) {
            return cast.name;
          })}'
              .replaceAll('(', '')
              .replaceAll(')', ''),
          style: const TextStyle(
            fontSize: FONT_SIZE_M,
          ),
        ),
      ),
    );
  }

  Widget _renderProductionCompanies(
    Movie movie,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(bottom: PADDING_NORMAL),
        child: Text(
          'Production Studios: ${movie.productionCompanies.map((cast) {
            return cast ?? '';
          })}'
              .replaceAll('(', '')
              .replaceAll(')', ''),
          style: const TextStyle(
            fontSize: FONT_SIZE_M,
          ),
        ),
      ),
    );
  }

  Widget _renderCrew(
    List<Crew> movieCrew,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          PADDING_NONE,
          PADDING_NONE,
          PADDING_NONE,
          PADDING_NORMAL,
        ),
        child: Text(
          'Directors: ${movieCrew.map((directors) {
            return directors.name;
          })}'
              .replaceAll('(', '')
              .replaceAll(')', ''),
          style: const TextStyle(
            fontSize: FONT_SIZE_M,
          ),
        ),
      ),
    );
  }

  Widget _renderButtons(
    Movie movie,
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
                  BUTTON_TEXT_HOMEPAGE,
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
                  BUTTON_TEXT_IMDB,
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
    Movie movie,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(
          top: PADDING_NORMAL,
        ),
        child: Text(
          'Genres: ${movie.genreNames.map((name) {
            return name;
          })}'
              .replaceAll('(', '')
              .replaceAll(')', ''),
          style: const TextStyle(
            fontSize: FONT_SIZE_M,
          ),
        ),
      ),
    );
  }

  Widget _renderRating(
    Movie movie,
    BuildContext moviePageContext,
  ) {
    return Column(
      children: [
        SizedBox(
          width: SizeConfig.screenWidth,
          child: const Padding(
            padding: EdgeInsets.only(
              top: PADDING_NORMAL,
            ),
            child: Text(
              RATING_TITLE,
              style: TextStyle(
                fontSize: FONT_SIZE_L,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: _authenticationBlocRateMovies,
        )
      ],
    );
  }

  Widget _authenticationBlocRateMovies(
    BuildContext context,
    AuthenticationState state,
  ) {
    if (state is AuthenticationAuthenticatedState) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: PADDING_NONE,
        ),
        child: RatingBar.builder(
          initialRating:
              (_movie.rating != 0 ? _movie.rating : _movie.voteAverage) / 2,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(
            horizontal: PADDING_SMALL,
          ),
          itemBuilder: (context, _) => const Icon(
            Icons.movie_filter_rounded,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            context.read<MoviesBloc>().add(
                  MoviesRateMovieEvent(
                    rating,
                    _movie.id,
                    state.authenticationRepository,
                  ),
                );
          },
        ),
      );
    }
    return Container();
  }

  Widget _renderReviews(
    List<Review> movieReviews,
  ) {
    return Column(
      children: [
        SizedBox(
          width: SizeConfig.screenWidth,
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: PADDING_NORMAL,
              horizontal: PADDING_LARGE,
            ),
            child: Text(
              REVIEW_TITLE,
              style: TextStyle(
                fontSize: FONT_SIZE_L,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 260,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: movieReviews.isNotEmpty
                ? movieReviews.map<Widget>(
                    (review) {
                      return ReviewCard(
                        review: review,
                      );
                    },
                  ).toList()
                : [
                    ReviewCard(
                      review: Review(
                        id: PLACEHOLDER_REVIEW_ID,
                        name: NO_REVIEW_TITLE,
                        content: NO_REVIEW_CONTENT,
                        time: PLACEHOLDER_REVIEW_TIME,
                      ),
                    )
                  ],
          ),
        ),
      ],
    );
  }

  Widget _renderRecommendations(List<Movie> movieRecommendations) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: PADDING_XL,
          ),
          width: SizeConfig.screenWidth,
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: PADDING_NORMAL,
            ),
            child: Text(
              RECOMMENDED_MOVIES,
              style: TextStyle(
                fontSize: FONT_SIZE_L,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 320,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: movieRecommendations.map<Widget>(
              (movie) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: PADDING_XL,
                  ),
                  child: MovieCard(
                    movie: movie,
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}

typedef callback = Function(
  BuildContext,
);
