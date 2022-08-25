import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class Authentication {
  Future<String> authenticate({
    required String username,
    required String password,
  });
}

class AuthenticationImpl implements Authentication {
  @override
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
        if (body["success"] == true) {
          var sessionUrl = Uri.parse(
              'https://api.themoviedb.org/3/authentication/session/new?api_key=840b96f3d20796ffdc21e782f84d3262');
          var sessionBody = {"request_token": body["request_token"]};
          var sessionResponse = await http.post(sessionUrl, body: sessionBody);
          if (sessionResponse.statusCode == 200) {
            var sessionBody = json.decode(sessionResponse.body);
            return sessionBody["session_id"];
          }
        }
      }
    }
    return "";
  }
}
