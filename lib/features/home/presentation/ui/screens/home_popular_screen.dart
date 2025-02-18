import 'package:flutter/material.dart';

class HomePopularScreen extends StatelessWidget {
  const HomePopularScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh tampilan daftar artikel populer (data dummy)
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5, // misal 5 artikel dummy
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
            title: Text('Popular News ${index + 1}'),
            subtitle: const Text('This is a short description of the popular news.'),
            onTap: () {
              // Navigasi ke detail artikel jika diperlukan
            },
          ),
        );
      },
    );
  }
}