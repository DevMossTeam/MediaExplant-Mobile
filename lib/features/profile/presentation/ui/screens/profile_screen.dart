import 'package:flutter/material.dart';
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
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const double _expandedHeight = 200;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ProfileViewModel(getProfile: ctx.read<GetProfile>()),
      child: Consumer<ProfileViewModel>(
        builder: (context, vm, _) {
          // Loading jika data belum siap
          if (vm.userData.isEmpty) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          // Jika belum login, tampilkan konten “belum login”
          if (!vm.isLoggedIn) {
            return const _NotLoggedInProfileContent();
          }

          // Jika sudah login, tampilkan header + TabBar
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: AppColors.primary,
                elevation: 6,
                onPressed: () => Navigator.push(
                  context,
                  SlideLeftRoute(page: SettingsScreen()),
                ),
                icon: const Icon(Icons.settings, color: Colors.white),
                label: const Text(
                  'Settings',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              body: NestedScrollView(
                headerSliverBuilder: (context, innerScrolled) => [
                  /// SliverAppBar dengan LayoutBuilder untuk hide/show konten sesuai scroll
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: AppColors.background,
                    expandedHeight: _expandedHeight,
                    automaticallyImplyLeading: false,
                    elevation: 0,

                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        // tinggi current appbar setiap kali scroll
                        final top = constraints.biggest.height;

                        // showAvatar hanya true jika nyaris fully expanded (200px).
                        final bool showAvatar = top > (_expandedHeight - 1);

                        // isCollapsed true jika sudah mendekati toolbar height (56px + tolerance)
                        final bool isCollapsed =
                            top <= (kToolbarHeight + 8);

                        return Container(
                          color:
                              showAvatar ? Colors.white : AppColors.background,
                          child: Stack(
                            children: [
                              // ======
                              // 1) Saat fully expanded (top > 199): tampilkan avatar + nama
                              // ======
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
                                              backgroundColor: vm
                                                          .profileImageProvider !=
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
                                                      style:
                                                          const TextStyle(
                                                        fontSize: 36,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
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

                              // ======
                              // 2) Saat sudah collapse (top <= 56+8): tampilkan AppBar custom: logo + search
                              // ======
                              if (isCollapsed)
                                Positioned.fill(
                                  child: Row(
                                    children: [
                                      // leading = logo app
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 5),
                                        child: Image.asset(
                                          'assets/images/app_logo.png',
                                          height: 32,
                                        ),
                                      ),

                                      // Spacer agar title/search di tengah
                                      const SizedBox(width: 12),

                                      // Title berupa container search/padding
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Container(
                                            height: 40,
                                            padding: const EdgeInsets
                                                .symmetric(horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            // Isi search box atau teks
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.search,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Cari konten...',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 15),
                                    ],
                                  ),
                                ),

                              // ======
                              // 3) Saat top di antara 199 dan 64: tampilkan background kosong putih (tanpa widget)
                              //    Ini mencegah Column overflow tapi tanpa konten apa pun.
                              // ======
                              if (!showAvatar && !isCollapsed)
                                const SizedBox.expand(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  /// SliverPersistentHeader untuk TabBar (latar putih, teks hitam)
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _TabBarDelegate(
                      TabBar(
                        indicatorColor: AppColors.primary,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black54,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 14,
                        ),
                        tabs: const [
                          Tab(text: 'Berita'),
                          Tab(text: 'Karya'),
                          Tab(text: 'Produk'),
                        ],
                      ),
                    ),
                  ),
                ],
                body: const TabBarView(
                  children: [
                    BeritaPage(),
                    KaryaPage(),
                    ProdukPage(),
                  ],
                ),
              ),
            ),
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
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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

/// Halaman “Berita” – contoh list berita
class BeritaPage extends StatelessWidget {
  const BeritaPage({Key? key}) : super(key: key);

  final List<Map<String, String>> _dummyBerita = const [
    {
      'judul': 'Berita 1: Flutter 3.10 Rilis',
      'preview':
          'Versi terbaru Flutter membawa peningkatan performa dan widget baru.',
      'gambar': 'https://via.placeholder.com/400x200',
    },
    {
      'judul': 'Berita 2: Provider vs Riverpod',
      'preview': 'Perbandingan state management Provider dan Riverpod.',
      'gambar': 'https://via.placeholder.com/400x200',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: _dummyBerita.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final b = _dummyBerita[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  b['gambar']!,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 140,
                    color: Colors.grey.shade300,
                    child:
                        const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b['judul']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        b['preview']!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Halaman “Karya” – contoh list karya user
class KaryaPage extends StatelessWidget {
  const KaryaPage({Key? key}) : super(key: key);

  // Contoh dummy – nantinya diganti data sebenarnya dari ProfileViewModel
  List<Map<String, String>> get _dummyKarya => const [
        {
          'judul': 'Karya 1: Foto Pemandangan',
          'deskripsi': 'Foto alam saat matahari terbenam.',
          'gambar': 'https://via.placeholder.com/400x200',
        },
        {
          'judul': 'Karya 2: Ilustrasi Digital',
          'deskripsi': 'Ilustrasi karakter untuk proyek game.',
          'gambar': 'https://via.placeholder.com/400x200',
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: _dummyKarya.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final k = _dummyKarya[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  k['gambar']!,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 60,
                    width: 60,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image,
                        color: Colors.grey, size: 30),
                  ),
                ),
              ),
              title: Text(
                k['judul']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                k['deskripsi']!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              onTap: () {
                // Arahkan ke detail karya, misalnya: Navigator.push(...)
              },
            ),
          );
        },
      ),
    );
  }
}

/// Halaman “Produk” – contoh list produk user
class ProdukPage extends StatelessWidget {
  const ProdukPage({Key? key}) : super(key: key);

  // Contoh dummy – nantinya diganti data sebenarnya dari ProfileViewModel
  List<Map<String, String>> get _dummyProduk => const [
        {
          'nama': 'Produk A',
          'harga': 'Rp100.000',
          'gambar': 'https://via.placeholder.com/400x200',
        },
        {
          'nama': 'Produk B',
          'harga': 'Rp250.000',
          'gambar': 'https://via.placeholder.com/400x200',
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: _dummyProduk.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final p = _dummyProduk[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  p['gambar']!,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 60,
                    width: 60,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image,
                        color: Colors.grey, size: 30),
                  ),
                ),
              ),
              title: Text(
                p['nama']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                p['harga']!,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  // Aksi “Beli” atau “Detail produk”
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Beli',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
