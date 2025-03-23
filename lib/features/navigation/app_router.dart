import 'package:flutter/material.dart';
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/auth/domain/usecases/sign_in.dart';
import 'package:mediaexplant/features/auth/domain/usecases/register_step1.dart';
import 'package:mediaexplant/features/auth/domain/usecases/verify_otp.dart';
import 'package:mediaexplant/features/auth/domain/usecases/register_step3.dart';
import 'package:mediaexplant/features/auth/presentation/logic/sign_in_viewmodel.dart';
import 'package:mediaexplant/features/auth/presentation/logic/sign_up_viewmodel.dart';
import 'package:mediaexplant/features/auth/presentation/ui/screens/sign_in_screen.dart';
import 'package:mediaexplant/features/auth/presentation/ui/screens/sign_up_screen.dart';
import 'package:mediaexplant/features/auth/presentation/ui/otp/sign_up_verify_email.dart';
import 'package:mediaexplant/features/auth/presentation/ui/screens/sign_up_input_screen.dart';
import 'package:mediaexplant/features/auth/presentation/ui/otp/forgot_password_verify_email.dart';
import 'package:mediaexplant/features/auth/presentation/ui/otp/change_email_verify_email.dart';
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
import 'package:mediaexplant/main.dart';
import 'package:provider/provider.dart';
import 'package:mediaexplant/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mediaexplant/features/auth/data/repositories/auth_repository_impl.dart';

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
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case '/login':
        return MaterialPageRoute(
          builder: (context) {
            return ChangeNotifierProvider<SignInViewModel>(
              create: (context) {
                // Ambil ApiClient dari context, pastikan sudah disediakan di main.dart
                final apiClient = Provider.of<ApiClient>(context, listen: false);
                final authRemoteDataSource = AuthRemoteDataSource(apiClient: apiClient);
                final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
                return SignInViewModel(signInUseCase: SignIn(authRepository));
              },
              child: const SignInScreen(),
            );
          },
        );
      case '/sign_up':
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<SignUpViewModel>(
            create: (context) {
              final apiClient = Provider.of<ApiClient>(context, listen: false);
              final authRemoteDataSource = AuthRemoteDataSource(apiClient: apiClient);
              final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
              return SignUpViewModel(
                registerStep1UseCase: RegisterStep1(authRepository),
                verifyOtpUseCase: VerifyOtp(authRepository),
                registerStep3UseCase: RegisterStep3(authRepository),
              );
            },
            child: const SignUpScreen(),
          ),
        );
      case '/sign_up_verify_email':
        if (settings.arguments is String) {
          final email = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<SignUpViewModel>(
              create: (context) {
                final apiClient = Provider.of<ApiClient>(context, listen: false);
                final authRemoteDataSource = AuthRemoteDataSource(apiClient: apiClient);
                final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
                return SignUpViewModel(
                  registerStep1UseCase: RegisterStep1(authRepository),
                  verifyOtpUseCase: VerifyOtp(authRepository),
                  registerStep3UseCase: RegisterStep3(authRepository),
                );
              },
              child: SignUpVerifyEmailScreen(email: email),
            ),
          );
        }
        return _errorRoute(settings.name);
      case '/sign_up_input_screen':
        return MaterialPageRoute(builder: (_) => const SignUpInputScreen());
      case '/forgot_password_verify_email':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordVerifyEmailScreen());
      case '/change_email_verify_email':
        return MaterialPageRoute(builder: (_) => const ChangeEmailVerifyEmailScreen());
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
