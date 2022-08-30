import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/app_config.dart';
import 'package:movies/data/models/movie_model.dart';
import 'package:movies/domain/repositories/authentication_repository.dart';

abstract class Movies {
  Future<List> getPopularMovies();

  Future<List> getTopRatedMovies();

  Future<List> getSearchMovies({
    String searchString = '',
  });

  Future<List> getRatedMovies({
    required AuthenticationRepository authenticationRepository,
  });

  Future<bool> postRateMovie({
    required AuthenticationRepository authenticationRepository,
    required num rating,
    required num movieID,
  });

  Future<List<MovieModel>> getMovieRecommendations({
    required String movieId,
  });

  Future<MovieModel> getMovie({
    required String movieId,
  });

  Future<List> getMovieCast({
    required String movieId,
  });

  Future<List<ReviewModel>> getMovieReviews({
    required String movieId,
  });

  Future<List<GenreModel>> getGenre();
}

class MoviesImpl implements Movies {
  @override
  Future<List<MovieModel>> getPopularMovies() async {
    dynamic results = [];
    for (var i = 1; i < 3; i++) {
      var url = Uri.parse(
          '${Conf.baseUrl.get}movie/popular?api_key=${Conf.apiKey.get}&language=en-US&page=$i');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        results += json.decode(
          Utf8Decoder().convert(
            response.bodyBytes,
          ),
        )['results'];
      }
    }
    return results
        .map<MovieModel>(
          (
            r,
          ) =>
              MovieModel.fromJSON(
            r,
          ),
        )
        .toList();
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    dynamic results = [];
    for (var i = 1; i < 3; i++) {
      var url = Uri.parse(
          '${Conf.baseUrl.get}movie/top_rated?api_key=${Conf.apiKey.get}&language=en-US&page=$i');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        results += json.decode(
          Utf8Decoder().convert(
            response.bodyBytes,
          ),
        )['results'];
      }
    }
    List<MovieModel> x = results
        .map<MovieModel>(
          (
            r,
          ) =>
              MovieModel.fromJSON(
            r,
          ),
        )
        .toList();
    return x;
  }

  @override
  Future<List<MovieModel>> getSearchMovies({
    String searchString = '',
  }) async {
    dynamic results;
    var url = Uri.parse(
        '${Conf.baseUrl.get}search/movie?api_key=${Conf.apiKey.get}&language=en-US&query=$searchString&page=1');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      results = json.decode(
        Utf8Decoder().convert(
          response.bodyBytes,
        ),
      )['results'];
    }
    return results
        .map<MovieModel>(
          (
            r,
          ) =>
              MovieModel.fromJSON(
            r,
          ),
        )
        .toList();
  }

  @override
  Future<List<MovieModel>> getRatedMovies({
    required AuthenticationRepository authenticationRepository,
  }) async {
    dynamic results;
    var url = Uri.parse('${Conf.baseUrl.get}account/testmanaam'
        '/rated/movies?api_key=${Conf.apiKey.get}'
        '&language=en-US&session_id=${authenticationRepository.sessionId}'
        '&sort_by=created_at.asc&page=1');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      results = json.decode(
        Utf8Decoder().convert(
          response.bodyBytes,
        ),
      )['results'];
    }
    return results
        .map<MovieModel>(
          (
            r,
          ) =>
              MovieModel.fromJSON(
            r,
          ),
        )
        .toList();
  }

  @override
  Future<bool> postRateMovie({
    required AuthenticationRepository authenticationRepository,
    required num rating,
    required num movieID,
  }) async {
    var body = {"value": (rating * 2).toString()};
    var url = Uri.parse(
      '${Conf.baseUrl.get}movie/${movieID.toString()}/rating?'
      'api_key=${Conf.apiKey.get}&'
      'session_id=${authenticationRepository.sessionId.toString()}',
    );
    var response = await http.post(
      url,
      body: body,
    );
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations({
    required String movieId,
  }) async {
    dynamic results;
    var url = Uri.parse(
        '${Conf.baseUrl.get}movie/$movieId/recommendations?api_key=${Conf.apiKey.get}&language=en-US&page=1');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      results = json.decode(
        Utf8Decoder().convert(
          response.bodyBytes,
        ),
      )['results'];
    }
    return results
        .map<MovieModel>(
          (
            r,
          ) =>
              MovieModel.fromJSON(
            r,
          ),
        )
        .toList();
  }

  @override
  Future<MovieModel> getMovie({
    required String movieId,
  }) async {
    dynamic results;
    var url = Uri.parse(
      '${Conf.baseUrl.get}movie/$movieId?api_key=${Conf.apiKey.get}&language=en-US',
    );
    var response = await http.get(url);
    if (response.statusCode == 200) {
      dynamic x = json.decode(
        Utf8Decoder().convert(
          response.bodyBytes,
        ),
      );
      results = MovieModel.fromJSON(
        json.decode(
          Utf8Decoder().convert(
            response.bodyBytes,
          ),
        ),
      );
    }
    return results;
  }

  @override
  Future<List> getMovieCast({
    required String movieId,
  }) async {
    dynamic cast;
    dynamic crew;
    var url = Uri.parse(
        '${Conf.baseUrl.get}movie/$movieId/credits?api_key=${Conf.apiKey.get}&language=en-US');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      cast = json.decode(
        Utf8Decoder().convert(
          response.bodyBytes,
        ),
      )['cast'];
      crew = json.decode(
        Utf8Decoder().convert(
          response.bodyBytes,
        ),
      )['crew'];
    }
    return [
      cast
          .map<CastModel>(
            (
              r,
            ) =>
                CastModel.fromJSON(
              r,
            ),
          )
          .toList(),
      crew
          .map<CrewModel>(
            (
              r,
            ) =>
                CrewModel.fromJSON(
              r,
            ),
          )
          .toList()
    ];
  }

  @override
  Future<List<ReviewModel>> getMovieReviews({
    required String movieId,
  }) async {
    dynamic results;
    var url = Uri.parse(
        '${Conf.baseUrl.get}movie/$movieId/reviews?api_key=${Conf.apiKey.get}&language=en-US&page=1');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      results = json.decode(
        Utf8Decoder().convert(
          response.bodyBytes,
        ),
      )['results'];
    }
    return results
        .map<ReviewModel>(
          (
            r,
          ) =>
              ReviewModel.fromJSON(
            r,
          ),
        )
        .toList();
  }

  @override
  Future<List<GenreModel>> getGenre() async {
    dynamic results;
    Uri url = Uri.parse(
      '${Conf.baseUrl.get}genre/movie/list?api_key=${Conf.apiKey.get}&language=en-US',
    );
    var response = await http.get(url);
    if (response.statusCode == 200) {
      results = json.decode(
        Utf8Decoder().convert(
          response.bodyBytes,
        ),
      )['genres'];
    }
    return results
        .map<GenreModel>(
          (
            r,
          ) =>
              GenreModel.fromJSON(
            r,
          ),
        )
        .toList();
  }
}
