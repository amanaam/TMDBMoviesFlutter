import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final bool adult;
  final List genres;
  final String? homepage;
  final int id;
  final String? imdbId;
  final String orignalLanguage;
  final String orignalTitle;
  final String title;
  final String? overview;
  final String? posterPath;
  final String releaseDate;
  final num vote_average;
  final List production_companies;
  final num? rating;

  const Movie({
    required this.adult,
    required this.genres,
    this.homepage,
    required this.id,
    this.imdbId,
    required this.orignalLanguage,
    required this.orignalTitle,
    this.overview,
    this.posterPath,
    required this.production_companies,
    this.rating,
    required this.releaseDate,
    required this.title,
    required this.vote_average,
  });

  @override
  List<Object> get props => [
        id,
      ];
}
