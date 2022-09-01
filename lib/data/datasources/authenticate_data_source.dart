import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../app_config.dart';

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
    Uri tokenUrl = Uri.parse(
      '${Conf.baseUrl.get}authentication/token/new?api_key=${Conf.apiKey.get}',
    );
    var tokenResponse = await http.get(
      tokenUrl,
    );
    if (tokenResponse.statusCode == 200) {
      var apiBody = {
        "username": username,
        "password": password,
        "request_token": json.decode(
          tokenResponse.body,
        )["request_token"]
      };
      Uri url = Uri.parse(
          '${Conf.baseUrl.get}authentication/token/validate_with_login?api_key=${Conf.apiKey.get}');
      var authResponse = await http.post(
        url,
        body: apiBody,
      );
      if (authResponse.statusCode == 200) {
        dynamic body = json.decode(
          tokenResponse.body,
        );
        if (body["success"] == true) {
          Uri sessionUrl = Uri.parse(
              '${Conf.baseUrl.get}authentication/session/new?api_key=${Conf.apiKey.get}');
          var sessionBody = {"request_token": body["request_token"]};
          var sessionResponse = await http.post(
            sessionUrl,
            body: sessionBody,
          );
          if (sessionResponse.statusCode == 200) {
            var sessionBody = json.decode(
              sessionResponse.body,
            );
            return sessionBody["session_id"];
          }
        }
      }
    }
    return "";
  }
}
