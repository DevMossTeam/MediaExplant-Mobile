import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  ArticleModel({
    required String id,
    required String title,
    required String content,
    required String imageUrl,
  }) : super(id: id, title: title, content: content, imageUrl: imageUrl);

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
    };
  }
}
