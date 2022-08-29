import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/data/models/movie_model.dart';
import 'package:movies/presentation_layer/pages/movie_page.dart';
import 'package:movies/presentation_layer/utils/size_config.dart';

class SearchMovieCard extends StatelessWidget {
  final MovieModel movie;

  const SearchMovieCard({
    Key? key,
    required this.movie,
  }) : super(key: key);

  get dateFormatter => null;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoviePage(
                movie: movie,
              ),
            ),
          );
        },
        child: SizedBox(
          width: SizeConfig.screenWidth,
          height: 100,
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Row(
              children: [
                SizedBox(
                  width: SizeConfig.screenWidth / 3,
                  height: 100,
                  child: Image.network(
                    movie.posterPath,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 2 * SizeConfig.screenWidth / 3 - 20,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 2 * SizeConfig.screenWidth / 3 - 20,
                          child: SingleChildScrollView(
                            child: Text(
                              movie.title,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2 * SizeConfig.screenWidth / 3 - 20,
                          child: Text(
                              movie.releaseDate.length >= 4
                                  ? movie.releaseDate.substring(0, 4)
                                  : '',
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 3)),
                        ),
                        SizedBox(
                          width: 2 * SizeConfig.screenWidth / 3 - 20,
                          child: ClipRect(
                            child: Text(
                              movie.overview,
                              style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 2,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 10,
            margin: const EdgeInsets.all(10),
          ),
        ),
      ),
    ]);
  }
}
