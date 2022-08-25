import 'package:flutter/material.dart';
import 'package:movies/presentation_layer/utils/constants.dart';

class CustomLinearProgressIndicator extends Center {
  const CustomLinearProgressIndicator({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: LINEAR_PROGRESS_WIDTH_HEIGHT,
        height: LINEAR_PROGRESS_WIDTH_HEIGHT,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
