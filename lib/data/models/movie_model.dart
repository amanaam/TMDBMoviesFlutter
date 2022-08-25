import 'package:movies/domain/entities/movie_entity.dart';

class MovieModel extends Movie {
  MovieModel({
    required bool adult,
    required List genres,
    String? homepage,
    required int id,
    String? imdbId,
    required String orignalLanguage,
    required String orignalTitle,
    required String title,
    String? overview,
    String? posterPath,
    required String releaseDate,
    required num vote_average,
    required List production_companies,
    num? rating,
  }) : super(
          adult: adult,
          genres: genres,
          homepage: homepage ?? '',
          id: id,
          imdbId: imdbId ?? '',
          orignalLanguage: orignalLanguage,
          orignalTitle: orignalTitle,
          title: title,
          overview: overview,
          posterPath: posterPath,
          releaseDate: releaseDate,
          vote_average: vote_average,
          production_companies: production_companies,
          rating: rating,
        );
  factory MovieModel.fromJSON(Map<String, dynamic> json) {
    return MovieModel(
      adult: json['adult'],
      genres: json['genres'],
      homepage: json['homepage'],
      id: json['id'],
      imdbId: json['imdbId'],
      orignalLanguage: json['orignal_language'],
      orignalTitle: json['orignal_title'],
      title: json['title'],
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'],
      vote_average: json['vote_average'],
      production_companies: json['production_companies'],
      rating: json['rating'] ?? 0,
    );
  }
}
