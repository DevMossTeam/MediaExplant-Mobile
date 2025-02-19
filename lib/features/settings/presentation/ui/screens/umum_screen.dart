import 'package:flutter/material.dart';

class UmumScreen extends StatelessWidget {
  const UmumScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Umum")),
      body: const Center(child: Text("Umum Screen")),
    );
  }
}