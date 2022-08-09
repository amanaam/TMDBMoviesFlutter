import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/widgets/movie_page.dart';

class ReviewCard extends StatelessWidget {
  final String author;
  final String content;

  const ReviewCard({
    Key? key,
    required this.author,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
        width: 300,
        height: 250,
        child: Card(
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: 400,
                  child: Text(
                    author,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                    maxLines: 2,
                  ),
                ),
              ),
              Text(
                content,
                style: const TextStyle(
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis),
                maxLines: 9,
              ),
            ]),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 4,
          margin: const EdgeInsets.fromLTRB(0, 5, 20, 0),
        ),
      ),
    ]);
  }
}
