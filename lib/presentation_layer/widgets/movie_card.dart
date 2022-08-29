import 'package:flutter/material.dart';
import 'package:movies/data/models/movie_model.dart';
import 'package:movies/presentation_layer/pages/movie_page.dart';
import 'package:movies/presentation_layer/utils/size_config.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;

  const MovieCard({
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
                    )),
          );
        },
        child: SizedBox(
          width: SizeConfig.screenWidth * 0.5,
          height: 340,
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: Stack(children: [
                    Image.network(
                      movie.posterPath,
                      fit: BoxFit.fill,
                      width: SizeConfig.screenWidth / 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Card(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          '  ${movie.rating == 0 ? movie.voteAverage.toStringAsFixed(1) : movie.rating.toStringAsFixed(1)}  ',
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ]),
                ),
                SizedBox(
                  width: 250,
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(children: [
                        Text(
                          movie.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Nunito'),
                          maxLines: 2,
                        ),
                        Text(
                            movie.releaseDate.length > 4
                                ? movie.releaseDate.substring(0, 4)
                                : '',
                            style: const TextStyle(
                              fontSize: 14,
                              overflow: TextOverflow.fade,
                            ))
                      ]),
                    ),
                  ),
                )
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
          ),
        ),
      ),
    ]);
  }
}
