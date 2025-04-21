import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediaexplant/features/bookmark/provider/bookmark_provider.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita_terkini_viewmodel.dart';
import 'package:mediaexplant/features/settings/logic/settings_viewmodel.dart';
import 'package:mediaexplant/features/settings/logic/umum_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/navigation/app_router.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/home_screen.dart';
import 'package:mediaexplant/features/profile/presentation/ui/screens/profile_screen.dart';

// Pastikan Anda mengimpor kelas-kelas berikut:
import 'package:mediaexplant/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mediaexplant/features/profile/domain/repositories/profile_repository.dart';
import 'package:mediaexplant/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mediaexplant/features/profile/domain/usecases/get_profile.dart';
import 'package:mediaexplant/features/profile/presentation/logic/profile_viewmodel.dart';
import 'package:mediaexplant/features/settings/logic/hubungi_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Provider untuk ApiClient
        Provider<ApiClient>(
          create: (_) => ApiClient(),
        ),
        // Provider untuk ProfileRemoteDataSource
        Provider<ProfileRemoteDataSource>(
          create: (_) => ProfileRemoteDataSource(),
        ),
        // Provider untuk ProfileRepository (menggunakan implementasi ProfileRepositoryImpl)
        Provider<ProfileRepository>(
          create: (ctx) => ProfileRepositoryImpl(
            remoteDataSource: ctx.read<ProfileRemoteDataSource>(),
          ),
        ),
        // Provider untuk use-case GetProfile
        Provider<GetProfile>(
          create: (ctx) => GetProfile(ctx.read<ProfileRepository>()),
        ),
        // Provider global untuk ProfileViewModel, dengan parameter required getProfile.
        ChangeNotifierProvider<ProfileViewModel>(
          create: (ctx) => ProfileViewModel(getProfile: ctx.read<GetProfile>())
            ..refreshUserData(),
        ),
        // Provider untuk Berita
        ChangeNotifierProvider(
          create: (_) => BeritaTerkiniViewmodel(),
        ),
        // Provider untuk Bookmark
        ChangeNotifierProvider(create: (ctx) => BookmarkProvider()),
            // provider untuk Reaksi
        ChangeNotifierProvider(create: (_) => ReaksiProvider()),
        // ✅ Provider untuk HubungiViewModel
        ChangeNotifierProvider<HubungiViewModel>(
          create: (ctx) => HubungiViewModel(apiClient: ctx.read<ApiClient>()),
        ),
        // ✅ Provider untuk HubungiViewModel
        ChangeNotifierProvider<SettingsViewModel>(
          create: (ctx) => SettingsViewModel(apiClient: ctx.read<ApiClient>()),
        ),
        ChangeNotifierProvider<UmumViewModel>(
          create: (ctx) => UmumViewModel(apiClient: ctx.read<ApiClient>()),
        ),
        ChangeNotifierProvider<KeamananViewModel>(
          create: (ctx) => KeamananViewModel(apiClient: ctx.read<ApiClient>()),
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
      debugShowCheckedModeBanner: false,
      title: 'MediaExplant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
        ),
      ),
      // Gunakan MainNavigationScreen sebagai halaman utama
      home: const MainNavigationScreen(),
      // onGenerateRoute tetap dapat digunakan untuk navigasi named route lain
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
      appBar: AppBar(title: const Text("Search")),
      body: const Center(child: Text("Search Screen")),
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

  // Daftar halaman
  final List<Widget> _pages = const [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // mengatur warna status bar
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.background,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: SizedBox(
          height: 75,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.white,
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            showSelectedLabels: false,
            showUnselectedLabels: false,
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
                  Icons.search,
                  color: AppColors.primary,
                  size: _currentIndex == 1 ? 30 : 24,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _currentIndex == 2 ? Icons.person : Icons.person_outline,
                  color: AppColors.primary,
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
