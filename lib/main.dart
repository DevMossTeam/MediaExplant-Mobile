import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/features/home/data/providers/berita_provider.dart';
import 'package:mediaexplant/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:mediaexplant/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:mediaexplant/features/notifications/domain/repositories/notification_repository.dart';
import 'package:mediaexplant/features/notifications/domain/usecases/get_notifications.dart';
import 'package:mediaexplant/features/notifications/presentation/logic/notifications_viewmodel.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:mediaexplant/features/navigation/app_router.dart';
import 'package:mediaexplant/features/profile/presentation/logic/profile_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/home_screen.dart';
import 'package:mediaexplant/features/profile/presentation/ui/screens/profile_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Provider untuk Profile view model.
        ChangeNotifierProvider<ProfileViewModel>(
          create: (_) => ProfileViewModel(),
        ),
        // Provider untuk remote data source dengan parameter yang diperlukan.
        Provider<NotificationRemoteDataSource>(
          create: (_) => NotificationRemoteDataSourceImpl(
            client: http.Client(),
            baseUrl:
                'https://api.example.com', // Ganti dengan URL dasar yang benar.
          ),
        ),
        // Provider untuk notification repository menggunakan remote data source.
        Provider<NotificationRepository>(
          create: (context) => NotificationRepositoryImpl(
            remoteDataSource: context.read<NotificationRemoteDataSource>(),
          ),
        ),
        // Provider untuk Notifications view model.
        ChangeNotifierProvider<NotificationsViewModel>(
          create: (context) => NotificationsViewModel(
            getNotifications: GetNotifications(
              context.read<NotificationRepository>(),
            ),
          ),
        ),
        // provider untuk berita
        ChangeNotifierProvider(create: (context) => BeritaProvider())
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
      debugShowCheckedModeBanner: false,
      title: 'MediaExplant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

/// Placeholder untuk Search
class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: const Center(child: Text("Search Screen")),
    );
  }
}

/// Placeholder untuk Notification
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
      bottomNavigationBar: Container(
        height: 75,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          showSelectedLabels: false, // Sembunyikan label
          showUnselectedLabels: false, // Sembunyikan label
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                color: AppColors.primary,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search, // Gunakan ikon yang sama
                color: AppColors.primary,
                size: _currentIndex == 1 ? 30 : 24, // Perbesar jika dipilih
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 2
                    ? Icons.notifications
                    : Icons.notifications_outlined,
                color: AppColors.primary,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 3 ? Icons.person : Icons.person_outline,
                color: AppColors.primary,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
