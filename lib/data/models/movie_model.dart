import 'package:movies/domain/entities/movie_entity.dart';
import 'package:movies/presentation_layer/utils/constants.dart';

class MovieModel extends Movie {
  MovieModel({
    required bool adult,
    required List genres,
    required String homepage,
    required int id,
    required String imdbId,
    required String orignalLanguage,
    required String orignalTitle,
    required String title,
    required String overview,
    required String posterPath,
    required String posterPathHD,
    required String releaseDate,
    required num voteAverage,
    required List productionCompanies,
    int? runtime,
    num? rating,
    required List genreNames,
  }) : super(
            adult: adult,
            genres: genres,
            homepage: homepage,
            id: id,
            imdbId: imdbId,
            orignalLanguage: orignalLanguage,
            orignalTitle: orignalTitle,
            title: title,
            overview: overview,
            posterPath: posterPath,
            releaseDate: releaseDate,
            voteAverage: voteAverage,
            productionCompanies: productionCompanies,
            rating: rating ?? 0,
            runtime: runtime ?? 0,
            posterPathHD: posterPathHD,
            genreNames: genreNames);
  factory MovieModel.fromJSON(Map<String, dynamic> json) {
    return MovieModel(
      adult: json['adult'] ?? false,
      genres: json['genre_ids'] ??
          json['genres'].map((genre) => genre['id']).toList() ??
          [],
      homepage: json['homepage'] ?? '',
      id: json['id'],
      imdbId: json['imdbId'] ?? '',
      orignalLanguage: json['orignal_language'] ?? '',
      orignalTitle: json['orignal_title'] ?? '',
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] != null
          ? IMAGE_POSTER_STARTING_URL_SMALL + json['poster_path']
          : IMAGE_POSTER_DEFAULT,
      posterPathHD: json['poster_path'] != null
          ? IMAGE_POSTER_STARTING_URL_HD + json['poster_path']
          : IMAGE_POSTER_DEFAULT,
      releaseDate: json['release_date'].length > 4
          ? json['release_date'].substring(0, 4)
          : '',
      voteAverage: json['vote_average'] ?? 0,
      productionCompanies: json['production_companies'] != null
          ? json['production_companies']
              .map((company) => company['name'])
              .toList()
          : [],
      rating: json['rating'] ?? 0,
      runtime: json['runtime'] ?? 0,
      genreNames: json['genres'] != null
          ? json['genres'].map((genre) => genre['name']).toList()
          : [],
    );
  }
}

class CastModel extends Cast {
  CastModel({
    required int id,
    required String name,
  }) : super(
          id: id,
          name: name,
        );
  factory CastModel.fromJSON(Map<String, dynamic> json) {
    return CastModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class CrewModel extends Crew {
  CrewModel({
    required int id,
    required String name,
    required String job,
  }) : super(
          id: id,
          name: name,
          job: job,
        );
  factory CrewModel.fromJSON(Map<String, dynamic> json) {
    return CrewModel(
      id: json['id'],
      name: json['name'],
      job: json['job'],
    );
  }
}

class GenreModel extends Genre {
  GenreModel({
    required int id,
    required String name,
  }) : super(
          id: id,
          name: name,
        );
  factory GenreModel.fromJSON(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class ReviewModel extends Review {
  ReviewModel({
    required String id,
    required String name,
    required String content,
    required String time,
  }) : super(
          id: id,
          name: name,
          content: content,
          time: time,
        );
  factory ReviewModel.fromJSON(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      name: json['author'],
      content: json['content'],
      time: json['created_at'],
    );
  }
}
