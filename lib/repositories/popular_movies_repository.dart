import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/repositories/user_repository.dart';

class PopularMoviesRepository {
  List popularMoviesList = [];

  Future<List> getPopularMovies(
      {required UserRepository userRepository}) async {
      for (var i = 1; i < 3; i++) {
        var url = Uri.parse(
            'https://api.themoviedb.org/3/movie/popular?api_key=840b96f3d20796ffdc21e782f84d3262&language=en-US&page=$i');
        var response = await http.get(url);
        if (response.statusCode == 200) {
          var body = json.decode(response.body);
          popularMoviesList += body["results"];
        }
      }
      return popularMoviesList;

  }
}
