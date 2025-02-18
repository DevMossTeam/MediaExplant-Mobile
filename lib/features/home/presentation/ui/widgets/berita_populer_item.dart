import 'package:flutter/material.dart';
import '../../../domain/entities/article.dart';

class BeritaPopulerItem extends StatelessWidget {
  final Article article;
  const BeritaPopulerItem({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        leading: Image.network(
          article.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(article.title),
        subtitle: Text(
          article.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.pushNamed(context, '/detail_article', arguments: article);
        },
      ),
    );
  }
}
