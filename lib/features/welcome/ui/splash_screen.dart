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
    // Tunda selama 2 detik, lalu navigasikan ke WelcomeScreen
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/welcome');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna latar belakang sesuai desain
      backgroundColor: const Color(0xFFB71C1C), // Atau Colors.red, sesuaikan
      body: SafeArea(
        child: Stack(
          children: [
            // Teks judul di tengah
            Align(
              alignment: Alignment.center,
              child: Text(
                'MediaExplant',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Teks keterangan di bagian bawah
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  'Aplikasi ini dipersembahkan untuk UKPM Explant\n'
                  'dalam tugasnya untuk memberikan informasi terbaru\n'
                  'dari Politeknik Negeri Jember',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
