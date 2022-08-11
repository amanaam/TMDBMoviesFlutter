import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/repositories/user_repository.dart';

class Genre {
  late String name;
  late int id;

  Genre(String genreName, int genreId) {
    name = genreName;
    id = genreId;
  }
}

class PopularMoviesRepository {
  List popularMoviesList = [];
  List<Genre> genres = [];

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

  Future<List> getGenres() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/genre/movie/list?api_key=840b96f3d20796ffdc21e782f84d3262&language=en-US');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      List<Genre> genreList = [];
      for (final e in body['genres']) {
        genreList.add(Genre(e['name'], e['id']));
      }
      genres = genreList;
    }
    return genres;
  }
}
