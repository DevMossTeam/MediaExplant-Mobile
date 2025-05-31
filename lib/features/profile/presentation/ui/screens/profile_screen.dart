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
          pageBuilder: (context, animation, secondaryAnimation) =>
              page,
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

/// ProfileScreen yang menggunakan ProfileViewModel.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const dummySavedArticles = [
    {
      "title":       "Artikel Tersimpan 1",
      "thumbnailUrl": "https://via.placeholder.com/300x200",
      "description": "Deskripsi singkat artikel tersimpan 1."
    },
    // … bisa tambah data dummy lainnya
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ProfileViewModel(getProfile: ctx.read<GetProfile>()),
      child: Consumer<ProfileViewModel>(
        builder: (context, vm, _) {
          // Tampilkan loading jika data lokal belum terisi
          if (vm.userData.isEmpty) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              elevation: 6,
              onPressed: () => Navigator.push(
                context,
                SlideLeftRoute(page: SettingsScreen()),
              ),
              icon: const Icon(Icons.settings, color: Colors.white),
              label: const Text('Settings',
                  style: TextStyle(color: Colors.white)),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endFloat,
            body: vm.isLoggedIn
                ? RefreshIndicator(
                    onRefresh: vm.refreshUserData,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        /// Kirim avatarImage apa adanya (boleh null)
                        ProfileHeader(
                          avatarImage: vm.profileImageProvider,
                          name:        vm.fullName,
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Saved Articles',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...dummySavedArticles.map((art) => Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: ListTile(
                                        leading: Image.network(
                                          art['thumbnailUrl']!,
                                          width: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (c, e, st) => const Icon(
                                            Icons.broken_image,
                                          ),
                                        ),
                                        title: Text(art['title']!),
                                        subtitle: Text(art['description']!),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const NotLoggedInProfileContent(),
          );
        },
      ),
    );
  }
}

/// Konten untuk user yang belum login.
class NotLoggedInProfileContent extends StatefulWidget {
  const NotLoggedInProfileContent({Key? key}) : super(key: key);
  @override
  _NotLoggedInProfileContentState createState() =>
      _NotLoggedInProfileContentState();
}

class _NotLoggedInProfileContentState
    extends State<NotLoggedInProfileContent>
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
    _avatarFadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
          parent: _controller, curve: Curves.easeOutBack),
    );
    _contentFadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(
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
            width: 200,
            height: 200,
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
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      );

  Widget _buildSubHeaderText() => FadeTransition(
        opacity: _contentFadeAnimation,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Silakan login untuk mengakses profil dan artikel tersimpan Anda. '
            'Nikmati pengalaman membaca yang lebih personal!',
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
            label: const Text('Login',
                style: TextStyle(color: Colors.white)),
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
            colors: [AppColors.background, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
    ]);
  }
}

/// Header profil untuk user yang sudah login.
/// avatarImage boleh null → fallback huruf+warna latar.
class ProfileHeader extends StatelessWidget {
  final ImageProvider? avatarImage;
  final String name;

  const ProfileHeader({
    Key? key,
    required this.avatarImage,
    required this.name,
  }) : super(key: key);

  // Helper untuk menentukan warna latar berdasarkan huruf pertama
  Color _avatarBackgroundColor() {
    if (name.isEmpty) return Colors.grey;
    final firstChar = name.trim()[0].toUpperCase();
    final code = firstChar.codeUnitAt(0);
    final colors = [
      Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.purple,
      Colors.teal, Colors.indigo, Colors.brown, Colors.cyan, Colors.amber,
    ];
    int idx = (code - 65) % colors.length;
    if (idx < 0) idx = 0;
    return colors[idx];
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: 300,
      pinned: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final pct = (constraints.maxHeight - kToolbarHeight) /
              (300 - kToolbarHeight);
          final isCollapsed = pct < 0.01;

          return FlexibleSpaceBar(
            centerTitle: true,
            title: null,
            background: isCollapsed
                ? const SizedBox.shrink()
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF9A0605),
                              Color(0xFFBF1E1C),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Container(color: Colors.black.withOpacity(.2)),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Hero(
                                tag: 'avatar_$name',
                                child: Material(
                                  elevation: 4,
                                  shape: const CircleBorder(),
                                  child: CircleAvatar(
                                    radius: 70,
                                    backgroundColor: avatarImage != null
                                        ? Colors.white
                                        : _avatarBackgroundColor(),
                                    backgroundImage: avatarImage,
                                    child: avatarImage == null
                                        ? Text(
                                            name.isNotEmpty
                                                ? name.trim()[0].toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 3,
                                      color: Colors.black54,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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

/// Widget untuk menampilkan judul section.
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontWeight: FontWeight.bold, color: AppColors.primary));
  }
}

/// Menampilkan daftar artikel tersimpan.
class SavedArticlesSection extends StatelessWidget {
  final List<Map<String, String>> articles;
  const SavedArticlesSection({Key? key, required this.articles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: articles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, i) {
        final art = articles[i];
        return SavedArticleCard(
          title:        art['title'] ?? '',
          thumbnailUrl: art['thumbnailUrl'] ?? '',
          description:  art['description'] ?? '',
        );
      },
    );
  }
}

/// Card untuk satu artikel tersimpan.
class SavedArticleCard extends StatelessWidget {
  final String title;
  final String thumbnailUrl;
  final String description;

  const SavedArticleCard({
    Key? key,
    required this.title,
    required this.thumbnailUrl,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleDetailScreen(
              title:        title,
              thumbnailUrl: thumbnailUrl,
              description:  description,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(.3),
                  offset: const Offset(0, 4),
                  blurRadius: 6),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: thumbnailUrl,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    thumbnailUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        height: 140,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image,
                            color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary)),
                    const SizedBox(height: 6),
                    Text(description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.text.withOpacity(.7),
                            height: 1.4)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Detail artikel page
class ArticleDetailScreen extends StatelessWidget {
  final String title;
  final String thumbnailUrl;
  final String description;

  const ArticleDetailScreen({
    Key? key,
    required this.title,
    required this.thumbnailUrl,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        children: [
          Hero(
            tag: thumbnailUrl,
            child: Image.network(
              thumbnailUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 250,
                color: Colors.grey.shade300,
                child:
                    const Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(description,
                style:
                    const TextStyle(fontSize: 16, height: 1.5, color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
