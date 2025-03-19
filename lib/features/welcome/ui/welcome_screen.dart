import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:mediaexplant/core/utils/app_colors.dart';

/// WelcomeScreen dengan 3 halaman onboarding menggunakan auto-slide dan Lottie animasi.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoSlideTimer;
  final int _numPages = 3;

  final List<Map<String, String>> _pages = [
    {
      "title": "Welcome to MediaExplant",
      "description": "Your personalized portal for the latest news and trends.",
      "lottie": "assets/animations/Welcome.json"
    },
    {
      "title": "Stay Updated",
      "description": "Get the most relevant updates tailored for you.",
      "lottie": "assets/animations/Animation_1742404418041.json"
    },
    {
      "title": "Modern Experience",
      "description": "Enjoy a seamless, interactive experience at your fingertips.",
      "lottie": "assets/animations/Animation_1742404469999.json"
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel(); // Hentikan timer sebelumnya jika ada
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % _numPages;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _markWelcomeSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcome', true);
  }

  void _onGetStarted() async {
    await _markWelcomeSeen();
    Navigator.pushReplacementNamed(context, '/home');
  }

  Widget _buildPageContent({
    required String lottie,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            lottie,
            height: 250,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 30),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _numPages,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, Colors.red.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                    _startAutoSlide(); // Reset timer saat user swipe
                  },
                  itemCount: _numPages,
                  itemBuilder: (context, index) {
                    return _buildPageContent(
                      lottie: _pages[index]["lottie"]!,
                      title: _pages[index]["title"]!,
                      description: _pages[index]["description"]!,
                    );
                  },
                ),
              ),
              _buildPageIndicator(),
              const SizedBox(height: 20),
              _currentPage == _numPages - 1
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton(
                        onPressed: _onGetStarted,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(height: 50),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
