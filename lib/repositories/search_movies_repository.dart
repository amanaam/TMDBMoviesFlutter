import 'dart:convert';

import 'package:http/http.dart' as http;

class SearchMoviesRepository {
  List searchMoviesList = [];

  Future<List> getSearchMovies({ String searchString=''}) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=840b96f3d20796ffdc21e782f84d3262&language=en-US&query=$searchString&page=1');
    print(url);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      searchMoviesList = body["results"];
      return body["results"];
    } else {
      return [];
    }
  }
}
