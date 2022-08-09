import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/repositories/user_repository.dart';

class MoviesRepository {
  var movieDetails;
  var movieCast;
  var movieDirectors;
  var movieRecommendations;
  var movieReviews;

  Future getMovie(
      {required int movieId}) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=840b96f3d20796ffdc21e782f84d3262&language=en-US');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      movieDetails = body;
      return body;
    } else {
      return [];
    }
  }

  Future getCast(
      {required int movieId}) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=840b96f3d20796ffdc21e782f84d3262&language=en-US');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      movieCast = body['cast'];
      movieDirectors = body['crew'].where((o) => o['job'] == 'Director').toList();
      return body;
    } else {
      return [];
    }
  }

  Future getRecommendations(
      {required int movieId}) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/recommendations?api_key=840b96f3d20796ffdc21e782f84d3262&language=en-US&page=1');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      movieRecommendations = body['results'];
      return body['results'];
    } else {
      return [];
    }
  }

  Future getReviews(
      {required int movieId}) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=840b96f3d20796ffdc21e782f84d3262&language=en-US&page=1');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      movieReviews = body['results'];
      return body['results'];
    } else {
      return [];
    }
  }
}
