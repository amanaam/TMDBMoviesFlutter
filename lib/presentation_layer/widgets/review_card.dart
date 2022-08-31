import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/data/models/movie_model.dart';
import 'package:movies/presentation_layer/utils/constants.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 250,
      padding: const EdgeInsets.only(
        left: PADDING_XL,
      ),
      child: Card(
        color: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(
            PADDING_LARGE,
          ),
          child: _renderReviewContent(
            review,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        elevation: 4,
        margin: const EdgeInsets.fromLTRB(
          PADDING_NONE,
          PADDING_SMALL,
          PADDING_NONE,
          PADDING_NORMAL,
        ),
      ),
    );
  }

  Widget _renderReviewContent(
    ReviewModel review,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: PADDING_SMALL,
          ),
          child: SizedBox(
            width: 400,
            child: Text(
              review.name,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: FONT_SIZE_M,
              ),
              maxLines: 2,
            ),
          ),
        ),
        Text(
          review.content,
          style: const TextStyle(
            fontSize: FONT_SIZE_S,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 9,
        ),
      ],
    );
  }
}
