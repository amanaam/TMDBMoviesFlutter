import 'package:flutter/material.dart';
import 'package:movies/data/models/movie_model.dart';
import 'package:movies/presentation_layer/pages/movie_page.dart';
import 'package:movies/presentation_layer/utils/constants.dart';
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
    return SizedBox(
      width: SizeConfig.screenWidth * 0.5,
      height: 340,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoviePage(
                movie: movie,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white70,
          padding: const EdgeInsets.all(
            PADDING_NONE,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 15,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            _renderMoviePictureWithRating(
              movie,
            ),
            _renderMovieTitle(
              movie,
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderMoviePictureWithRating(
    MovieModel movie,
  ) {
    return Padding(
      padding: const EdgeInsets.all(
        PADDING_NONE,
      ),
      child: SizedBox(
        width: SizeConfig.screenWidth * 0.5,
        height: 250,
        child: Stack(
          children: [
            Image.network(
              movie.posterPath,
              fit: BoxFit.fill,
              width: SizeConfig.screenWidth / 2,
            ),
            _renderMovieRating(movie),
          ],
        ),
      ),
    );
  }

  Widget _renderMovieRating(
    MovieModel movie,
  ) {
    return Padding(
      padding: const EdgeInsets.all(
        PADDING_NORMAL,
      ),
      child: Card(
        color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          '  ${movie.rating == 0 ? movie.voteAverage.toStringAsFixed(1) : movie.rating.toStringAsFixed(1)}  ',
          style: const TextStyle(
            fontSize: FONT_SIZE_M,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _renderMovieTitle(
    MovieModel movie,
  ) {
    return Container(
      width: 250,
      height: 70,
      padding: const EdgeInsets.all(
        PADDING_NORMAL,
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            _renderMovieName(movie),
            _renderMovieYear(movie),
          ],
        ),
      ),
    );
  }

  Widget _renderMovieName(
    MovieModel movie,
  ) {
    return Text(
      movie.title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: FONT_SIZE_S,
        fontFamily: 'Nunito',
        color: Colors.black,
      ),
      maxLines: 2,
    );
  }

  Widget _renderMovieYear(
    MovieModel movie,
  ) {
    return Text(
      movie.releaseDate,
      style: const TextStyle(
        fontSize: FONT_SIZE_XS,
        overflow: TextOverflow.fade,
        color: Colors.black,
      ),
    );
  }
}
