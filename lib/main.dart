import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediaexplant/core/utils/time_ago_util.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/bookmark/provider/bookmark_provider.dart';
import 'package:mediaexplant/features/comments/presentation/logic/komentar_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/karya/karya_repository.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/produkRepo/produk_repository.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_detail_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_populer_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_dari_kami_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_hot_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_teratas_view_model.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_terkait_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_topik_lainnya_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/desain_grafis_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/fotografi_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/karya_detail_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/karya_terkait_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/puisi_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/syair_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/produk/produk_detail_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/produk/produk_view_model.dart';
import 'package:mediaexplant/features/report/report_repository.dart';
import 'package:mediaexplant/features/report/report_viewmodel.dart';
import 'package:mediaexplant/features/search/search_screen.dart';
import 'package:mediaexplant/features/settings/logic/settings_viewmodel.dart';
import 'package:mediaexplant/features/settings/logic/umum_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/navigation/app_router.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/home_screen.dart';
import 'package:mediaexplant/features/profile/presentation/ui/screens/profile_screen.dart';
import 'package:mediaexplant/features/settings/logic/keamanan_viewmodel.dart';
import 'package:mediaexplant/features/reaksi/provider/Reaksi_provider.dart';
import 'package:mediaexplant/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mediaexplant/features/profile/domain/repositories/profile_repository.dart';
import 'package:mediaexplant/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mediaexplant/features/profile/domain/usecases/get_profile.dart';
import 'package:mediaexplant/features/profile/presentation/logic/profile_viewmodel.dart';
import 'package:mediaexplant/features/settings/logic/hubungi_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ← inisialisasi Firebase
  await loadUserLogin();
  timeago.setLocaleMessages('id', CustomIdMessages());

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
        // Provider untuk HubungiViewModel
        ChangeNotifierProvider<HubungiViewModel>(
          create: (ctx) => HubungiViewModel(apiClient: ctx.read<ApiClient>()),
        ),
        // Provider untuk HubungiViewModel
        ChangeNotifierProvider<SettingsViewModel>(
          create: (ctx) => SettingsViewModel(apiClient: ctx.read<ApiClient>()),
        ),
        ChangeNotifierProvider<UmumViewModel>(
          create: (ctx) => UmumViewModel(apiClient: ctx.read<ApiClient>()),
        ),
        ChangeNotifierProvider<KeamananViewModel>(
          create: (ctx) => KeamananViewModel(apiClient: ctx.read<ApiClient>()),
        ),

        // Provider untuk Berita
        ChangeNotifierProvider(create: (_) => BeritaDetailViewmodel()),
        ChangeNotifierProvider(
          create: (_) => BeritaTerbaruViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (_) => BeritaTeratasViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => BeritaPopulerViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (_) => BeritaDariKamiViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (_) => BeritaHotViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (_) => BeritaTerkaitViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (_) => BeritaTopikLainnyaViewmodel(),
        ),

        // Provider produk
        ChangeNotifierProvider(create: (_) => ProdukDetailViewmodel()),
        ChangeNotifierProvider(
          create: (_) => ProdukViewModel(ProdukRepository()),
        ),

        // provider karya
        ChangeNotifierProvider(create: (_) => KaryaDetailViewmodel()),
        ChangeNotifierProvider(
          create: (_) => PuisiViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (_) => SyairViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (_) => FotografiViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (_) => DesainGrafisViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (_) => KaryaTerkaitViewmodel(),
        ),

        // Provider untuk Bookmark
        ChangeNotifierProvider(create: (ctx) => BookmarkProvider()),
        // provider untuk Reaksi
        ChangeNotifierProvider(create: (_) => ReaksiProvider()),

        //komentar
        ChangeNotifierProvider(
          create: (_) => KomentarViewmodel(),
        ),

        // report
        ChangeNotifierProvider(
          create: (_) => ReportViewModel(ReportRepository()),
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
      initialRoute: '/', // Mulai dari splash screen
      onGenerateRoute: AppRouter.generateRoute,
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
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        //  _pages[_currentIndex],
        bottomNavigationBar: SizedBox(
          height: 80,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            // showSelectedLabels: false,
            // showUnselectedLabels: false,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.black.withAlpha(150),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
