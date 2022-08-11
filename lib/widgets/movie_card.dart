import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/widgets/movie_page.dart';

class MovieCard extends StatelessWidget {
  final String image;
  final String title;
  final String year;
  final String genre;
  final int id;
  final num rating;

  const MovieCard({
    Key? key,
    required this.image,
    required this.title,
    required this.year,
    required this.genre,
    required this.id,
    required this.rating,
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
          width: MediaQuery.of(context).size.width / 2,
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
                      image,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Card(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          '  ${rating.toStringAsFixed(1)}  ',
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
                        AutoSizeText(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              fontFamily: 'Nunito'),
                          maxLines: 2,
                        ),
                        AutoSizeText(
                            year.length > 4 ? year.substring(0, 4) : '',
                            style: const TextStyle(fontSize: 3))
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
