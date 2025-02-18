import 'package:flutter/material.dart';

class HomeLatestScreen extends StatelessWidget {
  const HomeLatestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh tampilan daftar artikel terbaru (data dummy)
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Image.network(
              'https://via.placeholder.com/80',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            title: Text('Latest News ${index + 1}'),
            subtitle: const Text('This is a short description of the latest news.'),
            onTap: () {
              // Navigasi ke detail artikel jika diperlukan
            },
          ),
        );
      },
    );
  }
}
