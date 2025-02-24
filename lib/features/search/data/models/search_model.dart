import '../../domain/entities/searh.dart';

class SearchModel extends Search {
  SearchModel({
    required String title,
    required String description,
    required String thumbnailUrl,
  }) : super(title: title, description: description, thumbnailUrl: thumbnailUrl);

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}
