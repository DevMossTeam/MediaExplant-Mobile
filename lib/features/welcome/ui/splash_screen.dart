import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// SplashScreen dengan background animasi Lottie dan staggered animations
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  
  // Animasi untuk logo (scaling & rotation)
  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoRotationAnimation;
  
  // Animasi untuk judul (title)
  late final Animation<double> _textFadeAnimation;
  late final Animation<Offset> _textSlideAnimation;
  
  // Animasi untuk tagline (sub judul)
  late final Animation<double> _taglineFadeAnimation;
  late final Animation<Offset> _taglineSlideAnimation;
  
  // Animasi untuk progress indicator
  late final Animation<double> _progressAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Satu controller untuk semua animasi selama 4 detik
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    
    // --- Logo Animations (0.0 - 0.3) ---
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOutBack),
      ),
    );
    _logoRotationAnimation = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );
    
    // --- Title Animations (0.3 - 0.5) ---
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.5, curve: Curves.easeIn),
      ),
    );
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.5, curve: Curves.easeOut),
      ),
    );
    
    // --- Tagline Animations (0.5 - 0.7) ---
    _taglineFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.7, curve: Curves.easeIn),
      ),
    );
    _taglineSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.7, curve: Curves.easeOut),
      ),
    );
    
    // --- Progress Indicator Animation (0.7 - 1.0) ---
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.linear),
      ),
    );
    
    // Mulai semua animasi secara bersamaan (dengan interval masing-masing)
    _controller.forward();
    
    // Navigasi ke halaman berikutnya saat animasi selesai
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  /// Widget background Lottie
  Widget _buildLottieBackground() {
    return SizedBox.expand(
      child: Lottie.asset(
        'assets/animations/Animation_1742097390792.json',
        fit: BoxFit.cover,
        repeat: true,
      ),
    );
  }
  
  /// Widget logo dengan animasi scale dan rotation
  Widget _buildLogo() {
    return ScaleTransition(
      scale: _logoScaleAnimation,
      child: RotationTransition(
        turns: _logoRotationAnimation,
        child: SvgPicture.asset(
          'assets/images/app_logo.svg',
          width: 100,
          height: 100,
        ),
      ),
    );
  }
  
  /// Widget judul (title) dengan animasi fade dan slide
  Widget _buildTitleText() {
    return FadeTransition(
      opacity: _textFadeAnimation,
      child: SlideTransition(
        position: _textSlideAnimation,
        child: const Text(
          'My Awesome App', // Ganti dengan nama aplikasi Anda
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
  
  /// Widget tagline dengan animasi fade dan slide
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
      animation: _controller,
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
              _buildTitleText(),
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
          // Background animasi Lottie
          _buildLottieBackground(),
          // Overlay semi-transparan untuk meningkatkan kontras
          Container(color: Colors.black.withOpacity(0.2)),
          // Konten utama yang dianimasikan
          SafeArea(child: _buildContent()),
        ],
      ),
    );
  }
}
