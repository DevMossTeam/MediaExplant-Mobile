import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/domain/usecases/forgot_password.dart';
import 'features/auth/presentation/logic/sign_in_viewmodel.dart';
import 'features/auth/presentation/logic/sign_up_viewmodel.dart';
import 'features/auth/presentation/logic/forgot_password_viewmodel.dart';
import 'features/auth/presentation/ui/screens/sign_in_screen.dart';
import 'features/auth/presentation/ui/screens/sign_up_screen.dart';
import 'features/auth/presentation/ui/screens/forgot_password_screen.dart';

void main() {
  final authRemoteDataSource = AuthRemoteDataSourceImpl();
  final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
  final signInUseCase = SignIn(authRepository);
  final signUpUseCase = SignUp(authRepository);
  final forgotPasswordUseCase = ForgotPassword(authRepository);
  final signInViewModel = SignInViewModel(signInUseCase: signInUseCase);
  final signUpViewModel = SignUpViewModel(signUpUseCase: signUpUseCase);
  final forgotPasswordViewModel = ForgotPasswordViewModel(forgotPasswordUseCase: forgotPasswordUseCase);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SignInViewModel>.value(value: signInViewModel),
        ChangeNotifierProvider<SignUpViewModel>.value(value: signUpViewModel),
        ChangeNotifierProvider<ForgotPasswordViewModel>.value(value: forgotPasswordViewModel),
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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SignInScreen(),
      routes: {
        '/sign_up': (context) => const SignUpScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
      },
    );
  }
}