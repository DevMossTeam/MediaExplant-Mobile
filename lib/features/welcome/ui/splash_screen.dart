import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Pastikan dependency lottie sudah ditambahkan di pubspec.yaml
import 'package:flutter_svg/flutter_svg.dart'; // Pastikan dependency flutter_svg sudah ditambahkan di pubspec.yaml

/// SplashScreen dengan background animasi Lottie
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation controller untuk logo (scaling & rotation)
  late final AnimationController _logoScaleController;
  late final Animation<double> _logoScaleAnimation;
  
  late final AnimationController _logoRotationController;
  late final Animation<double> _logoRotationAnimation;
  
  // Animation controller untuk judul
  late final AnimationController _textController;
  late final Animation<double> _textFadeAnimation;
  late final Animation<Offset> _textSlideAnimation;
  
  // Animation controller untuk tagline (sub judul)
  late final AnimationController _taglineController;
  late final Animation<double> _taglineFadeAnimation;
  late final Animation<Offset> _taglineSlideAnimation;
  
  // Animation controller untuk progress indicator
  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // --- Logo Scaling Animation ---
    _logoScaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoScaleController, curve: Curves.easeOutBack),
    );
    
    // --- Logo Rotation Animation ---
    _logoRotationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _logoRotationAnimation = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(parent: _logoRotationController, curve: Curves.easeOut),
    );
    
    // Mulai animasi logo
    _logoScaleController.forward();
    _logoRotationController.forward();
    
    // --- Judul (Title) Animation ---
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textController.forward();
    
    // --- Tagline Animation ---
    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _taglineFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );
    _taglineSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );
    // Menunda animasi tagline agar muncul setelah judul
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _taglineController.forward();
      }
    });
    
    // --- Progress Indicator Animation ---
    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_progressController);
    _progressController.forward();
    
    // Navigasi ke halaman berikutnya setelah 4 detik
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    });
  }
  
  @override
  void dispose() {
    _logoScaleController.dispose();
    _logoRotationController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    _progressController.dispose();
    super.dispose();
  }
  
  /// Widget untuk background Lottie (tidak diubah)
  Widget _buildLottieBackground() {
    return SizedBox.expand(
      child: Lottie.asset(
        'assets/animations/Animation_1742097390792.json',
        fit: BoxFit.cover,
        repeat: true,
      ),
    );
  }
  
  /// Widget logo menggunakan app logo dari assets SVG tanpa background lingkaran
  Widget _buildLogo() {
    return ScaleTransition(
      scale: _logoScaleAnimation,
      child: RotationTransition(
        turns: _logoRotationAnimation,
        child: SvgPicture.asset(
          'assets/images/app_logo.svg',
          width: 100,  // Ukuran logo diperbesar
          height: 100,
        ),
      ),
    );
  }
  
  /// Widget tagline dengan animasi fade dan slide (sub judul)
  Widget _buildTaglineText() {
    return FadeTransition(
      opacity: _taglineFadeAnimation,
      child: SlideTransition(
        position: _taglineSlideAnimation,
        child: const Text(
          'Mengalir Bersama Inovasi',
          style: TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            color: Colors.white70,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
  
  /// Widget progress indicator yang menampilkan status loading
  Widget _buildProgressIndicator() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: LinearProgressIndicator(
            value: _progressAnimation.value,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      },
    );
  }
  
  /// Menggabungkan semua widget utama pada splash screen
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
              const SizedBox(height: 10),
              _buildTaglineText(),
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
          // Background Lottie yang tetap digunakan
          _buildLottieBackground(),
          // Overlay semi-transparan untuk meningkatkan kontras tampilan
          Container(color: Colors.black.withOpacity(0.2)),
          // Konten utama dengan logo, teks, tagline, dan progress indicator
          SafeArea(child: _buildContent()),
        ],
      ),
    );
  }
}
