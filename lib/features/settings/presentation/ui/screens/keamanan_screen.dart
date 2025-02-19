import 'package:flutter/material.dart';

class KeamananScreen extends StatelessWidget {
  const KeamananScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keamanan')),
      body: const Center(
        child: Text('Ini adalah halaman Keamanan'),
      ),
    );
  }
}
