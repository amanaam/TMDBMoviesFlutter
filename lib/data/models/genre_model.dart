import '../../domain/entities/genre_entity.dart';

class GenreModel extends Genre {
  GenreModel({
    required String name,
    required int id,
  }) : super(
          name: name,
          id: id,
        );
  factory GenreModel.fromJSON(Map<String, dynamic> json) {
    return GenreModel(
      name: json["name"] ?? '',
      id: json["id"] ?? 0,
    );
  }
}
