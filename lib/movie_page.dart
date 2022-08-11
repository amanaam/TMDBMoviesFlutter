import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movies/cubit/authentication_cubit.dart';
import 'package:movies/cubit/movie_cubit.dart';
import 'package:movies/cubit/rated_movies_cubit.dart';
import 'package:movies/widgets/review_card.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/movie_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieCubit(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0x44000000),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocListener<RatedMoviesCubit, RatedMoviesState>(
            listener: (context, state) {
          if (state is RatedMovie) {
            Scaffold.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.green,
                content: Text("Movie successfully rated!")));
          } else if (state is RateMovieFailed) {
            Scaffold.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text("Failed to rate movie, Please try again!")));
          }
        }, child:
                BlocBuilder<MovieCubit, MovieState>(builder: (context, state) {
          if (state is MovieInitial) {
            context.read<MovieCubit>().loadMovie(widget.id);
            return const Center(
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      semanticsLabel: 'Linear progress indicator')),
            );
          } else if (state is LoadedMovie) {
            var movie = context.read<MovieCubit>().movie.movieDetails;
            var movieCast = context.read<MovieCubit>().movie.movieCast;
            var movieDirectors =
                context.read<MovieCubit>().movie.movieDirectors;
            var movieRecommendations =
                context.read<MovieCubit>().movie.movieRecommendations;
            var movieReviews = context.read<MovieCubit>().movie.movieReviews;
            return ListView(
              padding: const EdgeInsets.only(top: 0),
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: movie['poster_path'] != null
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w400' +
                              movie['poster_path'],
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          'https://play-lh.googleusercontent.com/IO3niAyss5tFXAQP176P0Jk5rg_A_hfKPNqzC4gb15WjLPjo5I-f7oIZ9Dqxw2wPBAg',
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          movie['title'] ?? '',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
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
                          width: MediaQuery.of(context).size.width,
                          child: AutoSizeText(
                            movie['overview'] ?? '',
                            style: const TextStyle(fontSize: 16),
                          )),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: AutoSizeText(
                              'Runtime: ${movie['runtime'].toString()} minutes',
                              style: const TextStyle(fontSize: 16),
                            ),
                          )),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: AutoSizeText(
                              'Rating: ${movie['vote_average'].toString()}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          )),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
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
                          width: MediaQuery.of(context).size.width,
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
                          width: MediaQuery.of(context).size.width,
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
                            minWidth: MediaQuery.of(context).size.width / 4,
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
                            minWidth: MediaQuery.of(context).size.width / 4,
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
                          )),
                          // SizedBox(
                          //   child: ButtonTheme(
                          //     minWidth: MediaQuery.of(context).size.width / 4,
                          //     height: 40,
                          //     buttonColor: Colors.green,
                          //     child: RaisedButton(
                          //       elevation: 5,
                          //       onPressed: () {},
                          //       child: const Text(
                          //         'Rate',
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: AutoSizeText(
                              'Rate',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: RatingBar.builder(
                          initialRating:
                              (movie['rating'] ?? movie['vote_average']) / 2 ??
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
                            context.read<RatedMoviesCubit>().rateMovie(
                                context
                                    .read<AuthenticationCubit>()
                                    .userRepository,
                                widget.id,
                                rating);
                          },
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: AutoSizeText(
                              'Reviews',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                                      author: 'No Reviews',
                                      content:
                                          'Add a review if you have seen this movie.')
                                ],
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: AutoSizeText(
                              'Recommendations',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )),
                      SizedBox(
                        height: 350,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: movieRecommendations.map<Widget>((movie) {
                            return MovieCard(
                              genre: '',
                              title: movie['title'] ?? '',
                              image: movie['poster_path'] != null
                                  ? 'https://image.tmdb.org/t/p/w200' +
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
            return const Center(
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      semanticsLabel: 'Linear progress indicator')),
            );
          }
        })),
      ),
    );
  }
}
