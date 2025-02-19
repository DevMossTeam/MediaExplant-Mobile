import 'package:flutter/material.dart';

class PusatBantuanScreen extends StatelessWidget {
  const PusatBantuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pusat Bantuan')),
      body: const Center(
        child: Text('Ini adalah halaman Pusat Bantuan'),
      ),
    );
  }
}
