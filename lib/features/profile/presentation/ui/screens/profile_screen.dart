import 'package:flutter/material.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/bookmark/bookmark_screen.dart/berita_bookmark.dart';
import 'package:mediaexplant/features/bookmark/bookmark_screen.dart/karya_bookmark.dart';
import 'package:mediaexplant/features/bookmark/bookmark_screen.dart/produk_bookmark.dart';
import 'package:mediaexplant/features/bookmark/viewmodel/berita_bookamark_viewmodel.dart';
import 'package:mediaexplant/features/bookmark/viewmodel/karya_bookmark_viewmodel.dart';
import 'package:mediaexplant/features/bookmark/viewmodel/produk_bookmark_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/profile/presentation/logic/profile_viewmodel.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/settings_screen.dart';
import 'package:mediaexplant/features/profile/domain/usecases/get_profile.dart';

/// Custom Route untuk transisi slide left
class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;
  SlideLeftRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: Curves.easeInOut));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static const double _expandedHeight = 200;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    // Saat tab berpindah, refresh data bookmark sesuai tab
    _tabController.addListener(() async {
      if (_tabController.indexIsChanging) return;

      final beritaVM =
          Provider.of<BeritaBookamarkViewmodel>(context, listen: false);
      final karyaVM =
          Provider.of<KaryaBookmarkViewmodel>(context, listen: false);
      final produkVM =
          Provider.of<ProdukBookmarkViewmodel>(context, listen: false);

      if (_tabController.index == 0) {
        await beritaVM.refresh(userLogin);
      } else if (_tabController.index == 1) {
        await karyaVM.refresh(userLogin);
      } else if (_tabController.index == 2) {
        await produkVM.refresh(userLogin);
      }
    });

    // Setelah frame pertama, langsung refresh tab pertama dan data profil
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = Provider.of<ProfileViewModel>(context, listen: false);
      await vm.refreshUserData();

      final beritaVM =
          Provider.of<BeritaBookamarkViewmodel>(context, listen: false);
      await beritaVM.refresh(userLogin);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ProfileViewModel(getProfile: ctx.read<GetProfile>()),
      child: Consumer<ProfileViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              elevation: 6,
              onPressed: () => Navigator.push(
                context,
                SlideLeftRoute(page: SettingsScreen()),
              ),
              icon: const Icon(Icons.settings, color: Colors.white),
              label:
                  const Text('Settings', style: TextStyle(color: Colors.white)),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endFloat,
            body: Builder(builder: (context) {
              // 1) Jika masih loading data profil
              if (vm.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // 2) Setelah loading, tapi belum login
              if (!vm.isLoggedIn) {
                return const _NotLoggedInProfileContent();
              }

              // 3) Sudah login → tampilkan profil + bookmark
              return NestedScrollView(
                headerSliverBuilder: (context, innerScrolled) => [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: AppColors.background,
                    expandedHeight: _expandedHeight,
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        final top = constraints.biggest.height;
                        final statusBarHeight =
                            MediaQuery.of(context).padding.top;
                        final bool isCollapsed =
                            top <= (kToolbarHeight + statusBarHeight + 8);
                        final bool showAvatar = top > (_expandedHeight - 1);

                        return Stack(
                          children: [
                            Container(
                              color: showAvatar
                                  ? Colors.white
                                  : AppColors.background,
                            ),
                            if (showAvatar)
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Hero(
                                        tag: 'avatar_${vm.fullName}',
                                        child: Material(
                                          elevation: 4,
                                          shape: const CircleBorder(),
                                          child: CircleAvatar(
                                            radius: 60,
                                            backgroundColor:
                                                vm.profileImageProvider !=
                                                        null
                                                    ? Colors.white
                                                    : _avatarBackgroundColor(
                                                        vm.fullName),
                                            backgroundImage:
                                                vm.profileImageProvider,
                                            child: vm.profileImageProvider ==
                                                    null
                                                ? Text(
                                                    vm.fullName.isNotEmpty
                                                        ? vm.fullName
                                                            .trim()[0]
                                                            .toUpperCase()
                                                        : '?',
                                                    style: const TextStyle(
                                                      fontSize: 36,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        vm.fullName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (isCollapsed)
                              Positioned(
                                top: statusBarHeight,
                                left: 0,
                                right: 0,
                                height: kToolbarHeight,
                                child: const Center(
                                  child: Text(
                                    'Bookmark',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            if (!showAvatar && !isCollapsed)
                              const SizedBox.expand(),
                          ],
                        );
                      },
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _TabBarDelegate(
                      TabBar(
                        controller: _tabController,
                        indicatorColor: AppColors.primary,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black54,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle:
                            const TextStyle(fontSize: 14),
                        tabs: const [
                          Tab(text: 'Berita'),
                          Tab(text: 'Karya'),
                          Tab(text: 'Produk'),
                        ],
                      ),
                    ),
                  ),
                ],
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab “Berita”
                    RefreshIndicator(
                      onRefresh: () async {
                        // sync data profil terlebih dahulu
                        await vm.refreshUserData();
                        // lalu refresh bookmark
                        await Provider.of<BeritaBookamarkViewmodel>(context,
                                listen: false)
                            .refresh(userLogin);
                      },
                      child: const BeritaBookmark(),
                    ),

                    // Tab “Karya”
                    RefreshIndicator(
                      onRefresh: () async {
                        await vm.refreshUserData();
                        await Provider.of<KaryaBookmarkViewmodel>(context,
                                listen: false)
                            .refresh(userLogin);
                      },
                      child: const KaryaBookmark(),
                    ),

                    // Tab “Produk”
                    RefreshIndicator(
                      onRefresh: () async {
                        await vm.refreshUserData();
                        await Provider.of<ProdukBookmarkViewmodel>(context,
                                listen: false)
                            .refresh(userLogin);
                      },
                      child: const ProdukBookmark(),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }

  /// Helper menentukan warna latar avatar (fallback inisial)
  Color _avatarBackgroundColor(String name) {
    if (name.isEmpty) return Colors.grey.shade400;
    final firstChar = name.trim()[0].toUpperCase();
    final code = firstChar.codeUnitAt(0);
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.brown,
      Colors.cyan,
      Colors.amber,
    ];
    int idx = (code - 65) % colors.length;
    if (idx < 0) idx = 0;
    return colors[idx];
  }
}

/// Delegate untuk SliverPersistentHeader menampung TabBar
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _TabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return false;
  }
}

/// Jika belum login, tampilkan animasi + teks ajakan
class _NotLoggedInProfileContent extends StatefulWidget {
  const _NotLoggedInProfileContent({Key? key}) : super(key: key);

  @override
  __NotLoggedInProfileContentState createState() =>
      __NotLoggedInProfileContentState();
}

class __NotLoggedInProfileContentState
    extends State<_NotLoggedInProfileContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _avatarFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _contentFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _avatarFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _contentFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAvatar() => FadeTransition(
        opacity: _avatarFadeAnimation,
        child: ClipOval(
          child: SizedBox(
            width: 160,
            height: 160,
            child: Lottie.asset(
              'assets/animations/Animation_1742098657264.json',
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

  Widget _buildHeaderText() => SlideTransition(
        position: _headerSlideAnimation,
        child: const Text(
          'Anda belum login',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      );

  Widget _buildSubHeaderText() => FadeTransition(
        opacity: _contentFadeAnimation,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Silakan login untuk mengakses profil pribadi, berita terbaru, karya, dan produk Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );

  Widget _buildLoginButton(BuildContext context) => FadeTransition(
        opacity: _contentFadeAnimation,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            icon: const Icon(Icons.login, color: Colors.white),
            label: const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      );

  Widget _buildTagline() => FadeTransition(
        opacity: _contentFadeAnimation,
        child: const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            'Bergabunglah dengan komunitas kami sekarang!',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                color: Colors.black45,
                fontStyle: FontStyle.italic),
          ),
        ),
      );

  Widget _buildBackground() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        _buildBackground(),
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  _buildAvatar(),
                  const SizedBox(height: 30),
                  _buildHeaderText(),
                  const SizedBox(height: 15),
                  _buildSubHeaderText(),
                  const SizedBox(height: 40),
                  _buildLoginButton(context),
                  const SizedBox(height: 20),
                  _buildTagline(),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
