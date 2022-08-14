import 'dart:convert';

import 'package:http/http.dart' as http;

class Genre {
  late String name;
  late int id;

  Genre(String genreName, int genreId) {
    name = genreName;
    id = genreId;
  }
}

class UserRepository {
  String sessionid = "";
  List<Genre> genres = [];
  Future<String> authenticate({
    required String username,
    required String password,
  }) async {
    var tokenUrl = Uri.parse(
        'https://api.themoviedb.org/3/authentication/token/new?api_key=840b96f3d20796ffdc21e782f84d3262');
    var tokenResponse = await http.get(tokenUrl);
    if (tokenResponse.statusCode == 200) {
      var apiBody = {
        "username": username,
        "password": password,
        "request_token": json.decode(tokenResponse.body)["request_token"]
      };
      var url = Uri.parse(
          'https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=840b96f3d20796ffdc21e782f84d3262');
      var authResponse = await http.post(url, body: apiBody);
      if (authResponse.statusCode == 200) {
        var body = json.decode(tokenResponse.body);
        print(body);
        if (body["success"] == true) {
          var sessionUrl = Uri.parse(
              'https://api.themoviedb.org/3/authentication/session/new?api_key=840b96f3d20796ffdc21e782f84d3262');
          var sessionBody = {"request_token": body["request_token"]};
          var sessionResponse = await http.post(sessionUrl, body: sessionBody);
          if (sessionResponse.statusCode == 200) {
            var sessionBody = json.decode(sessionResponse.body);
            // sessionid =session
            print(sessionid);
            sessionid = sessionBody["session_id"];
            return sessionBody["session_id"];
          }
        }
      }
    }
    return "";
  }

  Future<void> deleteToken() async {
    sessionid = '';
  }

  Future<bool> hasToken() async {
    return sessionid != '';
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
