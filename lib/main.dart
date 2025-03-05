import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// Import screens and view models from your project
import 'package:mediaexplant/features/navigation/app_router.dart';
import 'package:mediaexplant/features/profile/presentation/logic/profile_viewmodel.dart';
import 'package:mediaexplant/features/notifications/presentation/logic/notifications_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/home_screen.dart';
import 'package:mediaexplant/features/profile/presentation/ui/screens/profile_screen.dart';
import 'package:mediaexplant/features/notifications/presentation/ui/screens/notifications_screen.dart';
import 'package:mediaexplant/features/notifications/domain/usecases/get_notifications.dart';
import 'package:mediaexplant/features/notifications/domain/repositories/notification_repository.dart';
import 'package:mediaexplant/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:mediaexplant/features/notifications/data/datasources/notification_remote_data_source.dart';

/// Halaman placeholder untuk Search.
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

/// Halaman utama dengan Bottom Navigation Bar.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);
  
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    const SearchScreen(),
    // Pastikan NotificationsScreen tidak menggunakan const, sehingga dapat rebuild sesuai update.
    NotificationsScreen(),
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

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Profile view model provider.
        ChangeNotifierProvider<ProfileViewModel>(
          create: (_) => ProfileViewModel(),
        ),
        // Provider for the remote data source with required parameters.
        Provider<NotificationRemoteDataSource>(
          create: (_) => NotificationRemoteDataSourceImpl(
            client: http.Client(),
            baseUrl: 'https://api.example.com', // Replace with your actual base URL.
          ),
        ),
        // Provider for the notification repository using the remote data source.
        Provider<NotificationRepository>(
          create: (context) => NotificationRepositoryImpl(
            remoteDataSource: context.read<NotificationRemoteDataSource>(),
          ),
        ),
        // Notifications view model provider.
        ChangeNotifierProvider<NotificationsViewModel>(
          create: (context) => NotificationsViewModel(
            getNotifications: GetNotifications(
              context.read<NotificationRepository>(),
            ),
          ),
        ),
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
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
      builder: (context, child) => child!,
    );
  }
}