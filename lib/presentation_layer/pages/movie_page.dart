import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movies/bloc/authentication_bloc.dart';
import 'package:movies/cubit/movie_cubit.dart';
import 'package:movies/cubit/rated_movies_cubit.dart';
import 'package:movies/presentation_layer/utils/constants.dart';
import 'package:movies/presentation_layer/utils/size_config.dart';
import 'package:movies/presentation_layer/widgets/linear_progress_indicator_widget.dart';
import 'package:movies/presentation_layer/widgets/review_card.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/movie_card.dart';

class MoviePage extends StatefulWidget {
  final int id;

  const MoviePage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  get dateFormatter => null;

  updateRating(BuildContext context, num id, num rating) {
    BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
      if (state is AuthenticationAuthenticatedState) {
        // context
        //     .read<RatedMoviesCubit>()
        //     .rateMovie(state.userRepository, widget.id, rating);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieCubit(),
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
        body: BlocListener<RatedMoviesCubit, RatedMoviesState>(
          listener: (context, state) {
            if (state is RatedMovie) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(RATED_MOVIE_SUCCESSFUL)));
              // context.read<RatedMoviesCubit>().loadRatedMovies(
              //     context.read<AuthenticationCubit>().userRepository);
            } else if (state is RateMovieFailed) {
              //
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(RATED_MOVIE_FAILED)));
              // context.read<RatedMoviesCubit>().loadRatedMovies(
              //     context.read<AuthenticationCubit>().userRepository);
            }
          },
          child: BlocBuilder<MovieCubit, MovieState>(
            builder: (context, state) {
              if (state is MovieInitial) {
                context.read<MovieCubit>().loadMovie(widget.id);
                return const CustomLinearProgressIndicator();
              } else if (state is LoadedMovie) {
                var movie = context.read<MovieCubit>().movie.movieDetails;
                var movieCast = context.read<MovieCubit>().movie.movieCast;
                var movieDirectors =
                    context.read<MovieCubit>().movie.movieDirectors;
                var movieRecommendations =
                    context.read<MovieCubit>().movie.movieRecommendations;
                var movieReviews =
                    context.read<MovieCubit>().movie.movieReviews;
                return ListView(
                  padding: const EdgeInsets.only(top: 0),
                  children: [
                    SizedBox(
                      width: SizeConfig.screenWidth,
                      child: movie['poster_path'] != null
                          ? Image.network(
                              IMAGE_POSTER_STARTING_URL_HD +
                                  movie['poster_path'],
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              'https://play-lh.googleusercontent.com/IO3niAyss5tFXAQP176P0Jk5rg_A_hfKPNqzC4gb15WjLPjo5I-f7oIZ9Dqxw2wPBAg',
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(children: [
                          SizedBox(
                            width: SizeConfig.screenWidth,
                            child: Text(
                              movie['title'] ?? '',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidth,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                movie['release_date'].length > 4
                                    ? movie['release_date'].substring(0, 4)
                                    : '',
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 15),
                                maxLines: 2,
                              ),
                            ),
                          ),
                          SizedBox(
                              width: SizeConfig.screenWidth,
                              child: AutoSizeText(
                                movie['overview'] ?? '',
                                style: const TextStyle(fontSize: 16),
                              )),
                          SizedBox(
                              width: SizeConfig.screenWidth,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: AutoSizeText(
                                  'Runtime: ${movie['runtime'].toString()} minutes',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )),
                          SizedBox(
                              width: SizeConfig.screenWidth,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: AutoSizeText(
                                  'Rating: ${movie['vote_average'].toString()}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )),
                          SizedBox(
                              width: SizeConfig.screenWidth,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: AutoSizeText(
                                  'Cast: ${movieCast.map((cast) {
                                    return cast['name'] ?? '';
                                  })}'
                                      .replaceAll('(', '')
                                      .replaceAll(')', ''),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )),
                          SizedBox(
                              width: SizeConfig.screenWidth,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: AutoSizeText(
                                  'Directors: ${movieDirectors.map((directors) {
                                    return directors['name'] ?? '';
                                  })}'
                                      .replaceAll('(', '')
                                      .replaceAll(')', ''),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )),
                          SizedBox(
                              width: SizeConfig.screenWidth,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: AutoSizeText(
                                  'Production Studios: ${movie['production_companies'].map((cast) {
                                    return cast['name'] ?? '';
                                  })}'
                                      .replaceAll('(', '')
                                      .replaceAll(')', ''),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                  child: ButtonTheme(
                                minWidth: SizeConfig.screenWidth,
                                height: 40,
                                buttonColor: Colors.green,
                                child: RaisedButton(
                                    elevation: 5,
                                    onPressed: () {
                                      launch(movie['homepage'] ?? '');
                                    },
                                    child: const InkWell(
                                      child: Text(
                                        'Homepage',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                              )),
                              SizedBox(
                                child: ButtonTheme(
                                  minWidth: SizeConfig.screenWidth / 4,
                                  height: 40,
                                  buttonColor: Colors.green,
                                  child: RaisedButton(
                                      elevation: 5,
                                      onPressed: () {
                                        launch(
                                            'https://www.imdb.com/title/${movie['imdb_id'] ?? ''}');
                                      },
                                      child: const InkWell(
                                        child: Text(
                                          'IMDB Page',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              width: SizeConfig.screenWidth,
                              child: const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: AutoSizeText(
                                  'Rate',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: RatingBar.builder(
                              initialRating:
                                  (movie['rating'] ?? movie['vote_average']) /
                                          2 ??
                                      0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.movie_filter_rounded,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                updateRating(context, widget.id, rating);
                              },
                            ),
                          ),
                          SizedBox(
                              width: SizeConfig.screenWidth,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: AutoSizeText(
                                  'Reviews',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                            height: 260,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: movieReviews.length > 0
                                  ? movieReviews.map<Widget>((review) {
                                      return ReviewCard(
                                          author: review['author'] ?? '',
                                          content: review['content'] ?? '');
                                    }).toList()
                                  : [
                                      const ReviewCard(
                                          author: NO_REVIEW_TITLE,
                                          content: NO_REVIEW_CONTENT)
                                    ],
                            ),
                          ),
                          SizedBox(
                              width: SizeConfig.screenWidth,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: AutoSizeText(
                                  RECOMMENDED_MOVIES_TITLE,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                            height: 350,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children:
                                  movieRecommendations.map<Widget>((movie) {
                                return MovieCard(
                                  genre: '',
                                  title: movie['title'] ?? '',
                                  image: movie['poster_path'] != null
                                      ? IMAGE_POSTER_STARTING_URL_SMALL +
                                          movie['poster_path']
                                      : '',
                                  year: movie['release_date'] ?? '',
                                  id: movie['id'] ?? '',
                                  rating: movie['vote_average'] ?? 0,
                                );
                              }).toList(),
                            ),
                          ),
                        ]),
                      ),
                    )
                  ],
                );
              } else {
                return const CustomLinearProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
