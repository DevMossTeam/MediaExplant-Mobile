import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Pastikan dependensi lottie sudah ditambahkan di pubspec.yaml

/// SplashScreen dengan background animasi Lottie dari asset
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final Animation<double> _logoScaleAnimation;
  late final AnimationController _textController;
  late final Animation<double> _textFadeAnimation;
  late final Animation<Offset> _textSlideAnimation;
  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Animasi untuk logo
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    
    // Animasi untuk teks (fade & slide)
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    
    // Animasi untuk progress indicator
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );
    
    // Mulai animasi
    _logoController.forward();
    _textController.forward();
    _progressController.repeat();
    
    // Navigasi ke halaman berikutnya setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    });
  }
  
  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }
  
  /// Background animasi Lottie diambil dari asset
  Widget _buildLottieBackground() {
    return SizedBox.expand(
      child: Lottie.asset(
        'assets/animations/Animation_1742097390792.json',
        fit: BoxFit.cover,
        repeat: true,
      ),
    );
  }
  
  /// Widget logo dengan animasi scaling
  Widget _buildLogo() {
    return ScaleTransition(
      scale: _logoScaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.star,
            color: Colors.orange,
            size: 50,
          ),
        ),
      ),
    );
  }
  
  /// Widget teks judul dengan animasi fade dan slide
  Widget _buildTitleText() {
    return FadeTransition(
      opacity: _textFadeAnimation,
      child: SlideTransition(
        position: _textSlideAnimation,
        child: const Text(
          'Media Explant', // Teks diubah dari "Selamat Datang" menjadi "Explant"
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
  
  /// Widget progress indicator untuk memberi kesan loading
  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return LinearProgressIndicator(
            value: _progressAnimation.value,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 4,
          );
        },
      ),
    );
  }
  
  /// Gabungan semua konten utama di splash screen
  Widget _buildContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              const SizedBox(height: 20),
              _buildTitleText(),
              const SizedBox(height: 30),
              _buildProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background animasi Lottie dari asset
          _buildLottieBackground(),
          // Overlay semi-transparan untuk meningkatkan kontras
          Container(color: Colors.black.withOpacity(0.2)),
          // Konten utama
          SafeArea(child: _buildContent()),
        ],
      ),
    );
  }
}
