import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/notifications/presentation/ui/screens/notifications_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/settings_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/hubungi_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/keamanan_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/pusat_bantuan_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/tentang_screen.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/umum_screen.dart';
import 'package:mediaexplant/features/auth/presentation/ui/screens/sign_in_screen.dart';
import 'package:mediaexplant/features/auth/presentation/ui/screens/sign_up_screen.dart';
import 'package:mediaexplant/features/auth/presentation/ui/otp/sign_up_verify_email.dart';
import 'package:mediaexplant/features/auth/presentation/ui/screens/sign_up_input_screen.dart';
import 'package:mediaexplant/features/auth/presentation/ui/otp/forgot_password_verify_email.dart';
import 'package:mediaexplant/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mediaexplant/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mediaexplant/features/auth/presentation/logic/sign_in_viewmodel.dart';
import 'package:mediaexplant/features/auth/presentation/logic/sign_up_viewmodel.dart';
import 'package:mediaexplant/features/auth/domain/usecases/sign_in.dart';
import 'package:mediaexplant/features/auth/domain/usecases/register_step1.dart';
import 'package:mediaexplant/features/auth/domain/usecases/verify_otp.dart';
import 'package:mediaexplant/features/auth/domain/usecases/register_step3.dart';
import 'package:mediaexplant/features/settings/logic/umum_viewmodel.dart';
import 'package:mediaexplant/features/settings/logic/keamanan_viewmodel.dart';
import 'package:mediaexplant/features/welcome/ui/welcome_screen.dart';
import 'package:mediaexplant/features/welcome/ui/splash_screen.dart';
import 'package:mediaexplant/features/auth/presentation/ui/otp/change_email_form_screen.dart';
import 'package:mediaexplant/main.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Gunakan MainNavigationScreen sebagai entry point
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/welcome':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      // case '/detail_article':
      //   if (settings.arguments is Berita) {
      //     final berita = settings.arguments as Berita;
      //     return MaterialPageRoute(
      //       builder: (_) => DetailBeritaScreen(),
      //     );
      //   }
      //   return _errorRoute(settings.name);
      // Halaman Settings dan turunannya dengan transisi slide left.
      case '/settings':
        return _slideLeftRoute(const SettingsScreen());
      case '/settings/hubungi':
        return _slideLeftRoute(const HubungiScreen());
      case '/settings/keamanan':
        return _slideLeftRoute(const KeamananScreen());
      case '/settings/pengaturan_akun':
        return _slideLeftRoute(const SettingsScreen());
      case '/settings/pusat_bantuan':
        return _slideLeftRoute(const PusatBantuanScreen());
      case '/settings/tentang':
        return _slideLeftRoute(const TentangScreen());
      case '/settings/umum':
        // Ubah agar UmumScreen di-wrap dengan Provider<UmumViewModel> yang menyediakan apiClient
        return _slideLeftRoute(
          ChangeNotifierProvider<UmumViewModel>(
            create: (ctx) => UmumViewModel(apiClient: ctx.read<ApiClient>()),
            child: const UmumScreen(),
          ),
        );
        case '/change_email_form':
  return _slideLeftRoute(
    ChangeNotifierProvider<KeamananViewModel>(
      create: (ctx) => KeamananViewModel(apiClient: ctx.read<ApiClient>()),
      child: const ChangeEmailFormScreen(),
    ),
  );
      case '/notifications':
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case '/login':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return ChangeNotifierProvider<SignInViewModel>(
              create: (context) {
                final apiClient = Provider.of<ApiClient>(context, listen: false);
                final authRemoteDataSource =
                    AuthRemoteDataSource(apiClient: apiClient);
                final authRepository =
                    AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
                return SignInViewModel(signInUseCase: SignIn(authRepository));
              },
              child: const SignInScreen(),
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0, 1);
            const end = Offset.zero;
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case '/sign_up':
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<SignUpViewModel>(
            create: (context) {
              final apiClient = Provider.of<ApiClient>(context, listen: false);
              final authRemoteDataSource =
                  AuthRemoteDataSource(apiClient: apiClient);
              final authRepository =
                  AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
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
                final authRemoteDataSource =
                    AuthRemoteDataSource(apiClient: apiClient);
                final authRepository =
                    AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
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
        if (settings.arguments is String) {
          final email = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<SignUpViewModel>(
              create: (context) {
                final apiClient = Provider.of<ApiClient>(context, listen: false);
                final authRemoteDataSource =
                    AuthRemoteDataSource(apiClient: apiClient);
                final authRepository =
                    AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
                return SignUpViewModel(
                  registerStep1UseCase: RegisterStep1(authRepository),
                  verifyOtpUseCase: VerifyOtp(authRepository),
                  registerStep3UseCase: RegisterStep3(authRepository),
                );
              },
              child: SignUpInputScreen(email: email),
            ),
          );
        }
        return _errorRoute(settings.name);
      case '/forgot_password_verify_email':
        return MaterialPageRoute(
            builder: (_) => const ForgotPasswordVerifyEmailScreen());
      default:
        return _errorRoute(settings.name);
    }
  }

  /// Helper function for slide left transitions.
  static PageRouteBuilder _slideLeftRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0); // Start from the right
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
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