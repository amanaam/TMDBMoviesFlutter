import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/presentation_layer/pages/movie_page.dart';
import 'package:movies/presentation_layer/utils/size_config.dart';

class SearchMovieCard extends StatelessWidget {
  final String image;
  final String title;
  final String year;
  final String genre;
  final String description;
  final int id;

  const SearchMovieCard({
    Key? key,
    required this.image,
    required this.title,
    required this.year,
    required this.genre,
    required this.description,
    required this.id,
  }) : super(key: key);

  get dateFormatter => null;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MoviePage(id: id)),
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
                    image,
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
                              title,
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
                          child: AutoSizeText(
                              year.length >= 4 ? year.substring(0, 4) : '',
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 3)),
                        ),
                        SizedBox(
                          width: 2 * SizeConfig.screenWidth / 3 - 20,
                          child: ClipRect(
                            child: AutoSizeText(
                              description,
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
