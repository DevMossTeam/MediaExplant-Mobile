import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Tunda selama 2 detik, lalu navigasikan ke Welcome Screen
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      // Navigasi ke MainNavigationScreen (gunakan route '/main')
      Navigator.pushReplacementNamed(context, '/main');
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'MediaExplant',
          // Menggunakan headlineMedium, karena properti headline4 telah digantikan di versi Flutter terbaru
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}