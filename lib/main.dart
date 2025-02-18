import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/auth/presentation/logic/sign_in_viewmodel.dart';
import 'features/auth/presentation/ui/screens/sign_in_screen.dart';
import 'features/auth/presentation/ui/screens/reset_password_screen.dart';
import 'features/auth/presentation/ui/screens/sign_up_screen.dart';

void main() {
  final authRemoteDataSource = AuthRemoteDataSourceImpl();
  final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
  final signInUseCase = SignIn(authRepository);
  final signInViewModel = SignInViewModel(signInUseCase: signInUseCase);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SignInViewModel>.value(value: signInViewModel),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediaExplant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInScreen(),
      routes: {
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/sign_up': (context) => const SignUpScreen(),
      },
    );
  }
}