import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final bool adult;
  final List genres;
  final String homepage;
  final int id;
  final String imdbId;
  final String orignalLanguage;
  final String orignalTitle;
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final num voteAverage;
  final List productionCompanies;
  num rating;
  int runtime;
  final String posterPathHD;
  final List genreNames;

  Movie({
    required this.adult,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.imdbId,
    required this.orignalLanguage,
    required this.orignalTitle,
    required this.overview,
    required this.posterPath,
    required this.productionCompanies,
    required this.rating,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.runtime,
    required this.posterPathHD,
    required this.genreNames,
  });

  @override
  List<Object> get props => [
        id,
      ];
}

class Cast extends Equatable {
  final String name;
  final int id;

  Cast({
    required this.name,
    required this.id,
  });

  @override
  List<Object> get props => [
        id,
      ];
}

class Crew extends Equatable {
  final String name;
  final int id;
  final String job;

  Crew({
    required this.name,
    required this.id,
    required this.job,
  });

  @override
  List<Object> get props => [
        id,
      ];
}

class Genre extends Equatable {
  final String name;
  final int id;

  Genre({
    required this.name,
    required this.id,
  });

  @override
  List<Object> get props => [
        id,
      ];
}

class Review extends Equatable {
  final String name;
  final String id;
  final String content;
  final String time;

  Review({
    required this.content,
    required this.time,
    required this.name,
    required this.id,
  });

  @override
  List<Object> get props => [
        id,
      ];
}
