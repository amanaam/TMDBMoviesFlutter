import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/data/models/movie_model.dart';
import 'package:movies/presentation_layer/pages/movie_page.dart';
import 'package:movies/presentation_layer/utils/constants.dart';
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
    return Container(
      width: SizeConfig.screenWidth,
      height: 100,
      margin: const EdgeInsets.all(
        PADDING_NORMAL,
      ),
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
        child: Row(
          children: [
            _renderMovieImage(
              movie,
            ),
            _renderMovieDetails(
              movie,
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderMovieImage(
    MovieModel movie,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth / 3,
      height: 100,
      child: Image.network(
        movie.posterPath,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _renderMovieDetails(
    MovieModel movie,
  ) {
    return SizedBox(
      width: 2 * SizeConfig.screenWidth / 3 - 20,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(
          PADDING_NORMAL,
        ),
        child: Column(
          children: [
            _renderMovieTitle(
              movie,
            ),
            _renderMovieYear(
              movie,
            ),
            _renderMovieOverview(
              movie,
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderMovieTitle(
    MovieModel movie,
  ) {
    return SizedBox(
      width: 2 * SizeConfig.screenWidth / 3 - 20,
      child: SingleChildScrollView(
        child: Text(
          movie.title,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: FONT_SIZE_M,
            overflow: TextOverflow.ellipsis,
            color: Colors.black,
          ),
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _renderMovieYear(
    MovieModel movie,
  ) {
    return Container(
      padding: const EdgeInsets.only(
        top: PADDING_SMALL,
      ),
      width: 2 * SizeConfig.screenWidth / 3 - 20,
      child: Text(
        movie.releaseDate,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: FONT_SIZE_XS,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _renderMovieOverview(
    MovieModel movie,
  ) {
    return Container(
      padding: const EdgeInsets.only(
        top: PADDING_SMALL,
      ),
      width: 2 * SizeConfig.screenWidth / 3 - 20,
      child: ClipRect(
        child: Text(
          movie.overview,
          style: const TextStyle(
            fontSize: FONT_SIZE_S,
            overflow: TextOverflow.ellipsis,
            color: Colors.black,
          ),
          maxLines: 2,
        ),
      ),
    );
  }
}
