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

// Halaman placeholder untuk Search dan Notification
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: const Center(child: Text("Search Screen")),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
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
  const MainNavigationScreen({super.key});
  
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
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

/// Daftar route aplikasi
class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const MainNavigationScreen(),
    '/detail_article': (context) => const DetailArticleScreen(),
    '/settings': (context) => const SettingsScreen(),
    '/settings/hubungi': (context) => const HubungiScreen(),
    '/settings/keamanan': (context) => const KeamananScreen(),
    '/settings/pengaturan_akun': (context) => const SettingsScreen(),
    '/settings/pusat_bantuan': (context) => const PusatBantuanScreen(),
    '/settings/setting_notifikasi': (context) => const SettingNotifikasiScreen(),
    '/settings/tentang': (context) => const TentangScreen(),
    '/settings/umum': (context) => const UmumScreen(),
  };
}