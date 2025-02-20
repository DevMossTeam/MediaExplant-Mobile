import 'package:flutter/material.dart';

// Import fitur Home & Navigation
import 'package:mediaexplant/features/home/presentation/ui/screens/home_screen.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_article_screen.dart';
// Import fitur Settings
import 'package:mediaexplant/features/settings/presentation/ui/screens/settings_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/hubungi_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/keamanan_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/pusat_bantuan_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/setting_notifikasi_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/tentang_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/umum_screen.dart';
// Import fitur Profile
import 'package:mediaexplant/features/profile/presentation/ui/screens/profile_screen.dart';
// Import Welcome & Splash Screens
import 'package:mediaexplant/features/welcome/ui/welcome_screen.dart';
import 'package:mediaexplant/features/welcome/ui/splash_screen.dart';

/// Halaman placeholder untuk Search dan Notification
class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: const Center(child: Text("Search Screen")),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification")),
      body: const Center(child: Text("Notification Screen")),
    );
  }
}

/// Halaman utama dengan Bottom Navigation Bar
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);
  
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    HomeScreen(),
    SearchScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

/// Fungsi untuk menghasilkan route berdasarkan nama route yang diberikan.
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        // Layar awal: SplashScreen
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/welcome':
        // Setelah SplashScreen, navigasi ke WelcomeScreen
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case '/home':
        // Setelah WelcomeScreen, masuk ke halaman utama dengan BottomNavigationBar
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/detail_article':
        return MaterialPageRoute(builder: (_) => const DetailArticleScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/settings/hubungi':
        return MaterialPageRoute(builder: (_) => const HubungiScreen());
      case '/settings/keamanan':
        return MaterialPageRoute(builder: (_) => const KeamananScreen());
      case '/settings/pengaturan_akun':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/settings/pusat_bantuan':
        return MaterialPageRoute(builder: (_) => const PusatBantuanScreen());
      case '/settings/setting_notifikasi':
        return MaterialPageRoute(builder: (_) => const SettingNotifikasiScreen());
      case '/settings/tentang':
        return MaterialPageRoute(builder: (_) => const TentangScreen());
      case '/settings/umum':
        return MaterialPageRoute(builder: (_) => const UmumScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text("No route defined for ${settings.name}")),
          ),
        );
    }
  }
}