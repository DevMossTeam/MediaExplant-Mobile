import 'package:flutter/material.dart';

class DetailArticleScreen extends StatelessWidget {
  const DetailArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Untuk contoh, tampilkan placeholder detail article
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Article"),
      ),
      body: const Center(
        child: Text("Detail Article Screen"),
      ),
    );
  }
}
