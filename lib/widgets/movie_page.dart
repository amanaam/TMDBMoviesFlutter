import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/cubit/authentication_cubit.dart';
import 'package:movies/cubit/movie_cubit.dart';
import 'package:movies/widgets/review_card.dart';
import 'package:url_launcher/url_launcher.dart';

import 'movie_card.dart';

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
          icon:  const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          ),),
        body: BlocBuilder<MovieCubit, MovieState>(
        builder: (context, state) {
          if (state is MovieInitial){
            context.read<MovieCubit>().loadMovie(widget.id);
            return const Center(
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      semanticsLabel: 'Linear progress indicator')),
            );
          } else if (state is LoadedMovie){
            var movie = context.read<MovieCubit>().movie.movieDetails;
            var movieCast = context.read<MovieCubit>().movie.movieCast;
            var movieDirectors = context.read<MovieCubit>().movie.movieDirectors;
            var movieRecommendations = context.read<MovieCubit>().movie.movieRecommendations;
            var movieReviews = context.read<MovieCubit>().movie.movieReviews;
            return SingleChildScrollView(
              child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: movie['poster_path']!=null?Image.network(
                          'https://image.tmdb.org/t/p/w400' +
                              movie['poster_path'],
                          fit: BoxFit.cover,
                        ):Image.network(
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
                                movie['title']??'',
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
                                    movie['release_date'].length>4?movie['release_date'].substring(0, 4):'',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                       fontSize: 15),
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            SizedBox(
                            width: MediaQuery.of(context).size.width,
                              child: AutoSizeText(
                                movie['overview']??'',
                                style: const TextStyle(
                                  fontSize: 16),
                              )
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: AutoSizeText(
                                    'Runtime: ${movie['runtime'].toString()} minutes',
                                    style: const TextStyle(
                                        fontSize: 16),
                                  ),
                                )
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: AutoSizeText(
                                    'Cast: ${movieCast.map(
                                            (cast){return cast['name']??'';})}'
                                        .replaceAll('(','')
                                        .replaceAll(')',''),
                                    style: const TextStyle(
                                        fontSize: 16),
                                  ),
                                )
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: AutoSizeText(
                                    'Directors: ${movieDirectors.map(
                                            (directors){return directors['name']??'';})}'
                                        .replaceAll('(','')
                                        .replaceAll(')',''),
                                    style: const TextStyle(
                                        fontSize: 16),
                                  ),
                                )
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: AutoSizeText(
                                    'Production Studios: ${movie['production_companies'].map(
                                            (cast){return cast['name']??'';})}'
                                        .replaceAll('(','')
                                        .replaceAll(')',''),
                                    style: const TextStyle(
                                        fontSize: 16),
                                  ),
                                )
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    child: InkWell(
                                      child: const Text('Homepage',style: TextStyle(
                                          fontSize: 16, color: Colors.blue),),
                                      onTap: () => launch(movie['homepage']??'')
                                      )
                                ),
                                SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: InkWell(
                                          child: const Text('IMDB Page',style: TextStyle(
                                              fontSize: 16, color: Colors.blue),),
                                          onTap: () => launch('https://www.imdb.com/title/${movie['imdb_id']??''}')
                                      ),
                                    )
                                ),
                              ],
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: AutoSizeText(
                                    'Reviews',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                            ),
                            SizedBox(
                              height: 260,
                              child: Expanded(
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: movieReviews.length>0?movieReviews.map<Widget>((review){
                                    return ReviewCard(author: review['author']??'', content: review['content']??'');
                                  }).toList():[ReviewCard(author: 'No Reviews', content: 'Add a review if you have seen this movie.')],
                                ),
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: AutoSizeText(
                                    'Recommendations',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                            ),
                            SizedBox(
                              height: 350,
                              child: Expanded(
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: movieRecommendations.map<Widget>((movie){
                                    return MovieCard(
                                      genre: '',
                                      title: movie['title']??'',
                                      image:
                                      movie['poster_path']!=null?
                                      'https://image.tmdb.org/t/p/w200'
                                          + movie['poster_path']:'',
                                      year: movie['release_date']??'',
                                      id: movie['id']??'',);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ]
                          ),
                        ),
                      )
                    ],
                  ),
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
        }
    ),
      ),
    );
  }
}