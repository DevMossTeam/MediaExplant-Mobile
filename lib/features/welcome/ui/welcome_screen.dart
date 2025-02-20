import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkWelcomeStatus();
  }

  // Cek apakah welcome sudah pernah ditampilkan sebelumnya
  Future<void> _checkWelcomeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasSeenWelcome = prefs.getBool('hasSeenWelcome') ?? false;
    if (hasSeenWelcome) {
      // Jika sudah, langsung navigasi ke halaman home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Tandai bahwa welcome sudah ditampilkan
  Future<void> _markWelcomeSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcome', true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Tampilkan loading indicator saat pengecekan
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Tampilan halaman Welcome
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Konten utama Welcome (gambar, teks, dll.)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome to MediaExplant!',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Discover news and updates tailored just for you.',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    // Tambahkan widget atau gambar sesuai kebutuhan
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  await _markWelcomeSeen();
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Get Started'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}