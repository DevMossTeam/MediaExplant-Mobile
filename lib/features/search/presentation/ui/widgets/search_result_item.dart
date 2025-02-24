import 'package:flutter/material.dart';
import '../../../domain/entities/searh.dart';

class SearchResultItem extends StatelessWidget {
  final Search search;
  const SearchResultItem({Key? key, required this.search}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        leading: Image.network(
          search.thumbnailUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(
          search.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          search.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          // Navigasi ke detail artikel jika diperlukan
        },
      ),
    );
  }
}
