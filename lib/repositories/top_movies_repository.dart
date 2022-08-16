import 'dart:convert';

import 'package:http/http.dart' as http;

class TopMoviesRepository {
  List topMoviesList = [];

  Future<List> getTopRatedMovies() async {
    for (var i = 1; i < 3; i++) {
      var url = Uri.parse(
          'https://api.themoviedb.org/3/movie/top_rated?api_key=840b96f3d20796ffdc21e782f84d3262&language=en-US&page=$i');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        topMoviesList += body['results'];
      }
    }
    return topMoviesList;
  }
}
