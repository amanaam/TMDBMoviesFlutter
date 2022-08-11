import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/repositories/user_repository.dart';

class RatedMoviesRepository {
  List ratedMoviesList = [];

  Future<List> getRatedMovies({required UserRepository userRepository}) async {
    var url = Uri.parse('https://api.themoviedb.org/3/account/testmanaam'
        '/rated/movies?api_key=840b96f3d20796ffdc21e782f84d3262'
        '&language=en-US&session_id=${userRepository.sessionid}'
        '&sort_by=created_at.asc&page=1');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      ratedMoviesList = body["results"];
    }
    return ratedMoviesList;
  }

  Future<bool> postRateMovie(
      {required UserRepository userRepository,
      required num rating,
      required num movieID}) async {
    var body = {"value": (rating * 2).toString()};
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/${movieID.toString()}/rating?'
        'api_key=840b96f3d20796ffdc21e782f84d3262&'
        'session_id=${userRepository.sessionid.toString()}');
    var response = await http.post(url, body: body);
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }
}
