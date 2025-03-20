import 'package:flutter/material.dart';
import 'package:mediaexplant/features/auth/presentation/ui/screens/sign_in_screen.dart';
import 'package:mediaexplant/features/auth/presentation/ui/screens/sign_up_screen.dart';
import 'package:mediaexplant/features/auth/presentation/ui/otp/sign_up_verify_email.dart';
import 'package:mediaexplant/features/auth/presentation/ui/screens/sign_up_input_screen.dart';
import 'package:mediaexplant/main.dart';
import 'package:mediaexplant/features/home/data/models/berita.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_berita_screen.dart';
import 'package:mediaexplant/features/notifications/presentation/ui/screens/notifications_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/settings_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/hubungi_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/keamanan_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/pusat_bantuan_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/setting_notifikasi_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/tentang_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/umum_screen.dart';
import 'package:mediaexplant/features/welcome/ui/welcome_screen.dart';
import 'package:mediaexplant/features/welcome/ui/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/welcome':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case '/home':
        // Pastikan widget ini menampilkan navbar (misalnya MainNavigationScreen)
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      case '/detail_article':
        if (settings.arguments is Berita) {
          final berita = settings.arguments as Berita;
          return MaterialPageRoute(
            builder: (_) => DetailBeritaScreen(berita: berita),
          );
        }
        return _errorRoute(settings.name);
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
      case '/notifications':
        return MaterialPageRoute(builder: (_) => NotificationsScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case '/sign_up':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case '/sign_up_verify_email':
        return MaterialPageRoute(builder: (_) => const SignUpVerifyEmailScreen());
      case '/sign_up_input_screen':
        return MaterialPageRoute(builder: (_) => const SignUpInputScreen());
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Not Found")),
        body: Center(child: Text("No route defined for $routeName")),
      ),
    );
  }
}