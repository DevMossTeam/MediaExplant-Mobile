import 'package:flutter/material.dart';

class SettingNotifikasiScreen extends StatelessWidget {
  const SettingNotifikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting Notifikasi')),
      body: const Center(
        child: Text('Ini adalah halaman Setting Notifikasi'),
      ),
    );
  }
}
