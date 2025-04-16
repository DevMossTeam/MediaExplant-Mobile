import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/profile/presentation/logic/profile_viewmodel.dart';
import 'package:mediaexplant/features/settings/presentation/ui/screens/settings_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

/// ProfileScreen yang menggunakan ProfileViewModel untuk mengecek status login
/// dan menampilkan konten profil yang sesuai.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  // Data dummy untuk artikel tersimpan
  static const List<Map<String, String>> dummySavedArticles = [
    {
      "title": "Artikel Tersimpan 1",
      "thumbnailUrl": "https://via.placeholder.com/300x200",
      "description": "Deskripsi singkat artikel tersimpan 1 yang sangat menarik dan informatif.",
    },
    // ... data dummy lainnya
  ];

  @override
  Widget build(BuildContext context) {
    // Provider akan otomatis memanggil _loadUserData() di konstruktor
return ChangeNotifierProvider(
  create: (ctx) => ProfileViewModel(
    getProfile: ctx.read<GetProfile>(),
  ),
  child: Consumer<ProfileViewModel>(
    builder: (context, profileVM, child) {
      // Tampilkan indikator loading ketika _userData masih kosong.
      if (profileVM.userData.isEmpty) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      // Gunakan langsung getter dari viewmodel.
      final isLoggedIn = profileVM.isLoggedIn;

      // Mapping data dari viewmodel.
      final profile = {
        "name": profileVM.fullName,
        "avatarUrl": profileVM.profilePic,
      };

      return Scaffold(
        backgroundColor: AppColors.background,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          elevation: 6,
          onPressed: () {
            Navigator.push(
              context,
              SlideLeftRoute(page: SettingsScreen()),
            );
          },
          icon: const Icon(Icons.settings, color: Colors.white),
          label: const Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: isLoggedIn
            ? LoggedInProfileContent(profile: profile, articles: dummySavedArticles)
            : const NotLoggedInProfileContent(),
      );
    },
  ),
);
  }
}

/// Widget yang menampilkan konten profil bagi pengguna yang sudah login.
class LoggedInProfileContent extends StatelessWidget {
  final Map<String, String> profile;
  final List<Map<String, String>> articles;
  const LoggedInProfileContent({
    Key? key,
    required this.profile,
    required this.articles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Header profil dengan gradient dan avatar.
          ProfileHeader(profile: profile),
          // Konten utama berisi judul dan daftar artikel tersimpan.
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SectionTitle(title: 'Saved Articles'),
                  const SizedBox(height: 12),
                  SavedArticlesSection(articles: articles),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget yang menampilkan konten ketika pengguna belum login.
class NotLoggedInProfileContent extends StatefulWidget {
  const NotLoggedInProfileContent({Key? key}) : super(key: key);

  @override
  _NotLoggedInProfileContentState createState() =>
      _NotLoggedInProfileContentState();
}

class _NotLoggedInProfileContentState extends State<NotLoggedInProfileContent>
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

    _avatarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), end: Offset.zero)
      .animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack)
      );

    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAvatar() {
    return FadeTransition(
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
  }

  Widget _buildHeaderText() {
    return SlideTransition(
      position: _headerSlideAnimation,
      child: const Text(
        'Anda belum login',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSubHeaderText() {
    return FadeTransition(
      opacity: _contentFadeAnimation,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Silakan login untuk mengakses profil dan artikel tersimpan Anda. '
          'Nikmati pengalaman membaca yang lebih personal serta rekomendasi konten sesuai minat Anda!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return FadeTransition(
      opacity: _contentFadeAnimation,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          icon: const Icon(Icons.login, color: Colors.white),
          label: const Text(
            'Login',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          ),
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return FadeTransition(
      opacity: _contentFadeAnimation,
      child: const Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Text(
          'Bergabunglah dengan komunitas kami sekarang!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black45,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildDecorativeBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.background, Colors.blue.shade50],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildDecorativeBackground(),
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
      ],
    );
  }
}

/// Widget header untuk profil yang sudah login.
class ProfileHeader extends StatelessWidget {
  final Map<String, String> profile;
  const ProfileHeader({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false, // Nonaktifkan tombol back
      expandedHeight: 300,
      pinned: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          double percentage = (constraints.maxHeight - kToolbarHeight) /
              (300 - kToolbarHeight);
          bool isCollapsed = percentage < 0.01;

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
                      Container(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Hero(
                                tag: 'avatar_${profile["avatarUrl"]}',
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundColor: Colors.white,
                                  backgroundImage: CachedNetworkImageProvider(
                                    profile["avatarUrl"]!,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                profile["name"]!,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 3,
                                      color: Colors.black54,
                                      offset: Offset(0, 2),
                                    )
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
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
    );
  }
}

/// Widget untuk menampilkan daftar artikel tersimpan.
class SavedArticlesSection extends StatelessWidget {
  final List<Map<String, String>> articles;
  const SavedArticlesSection({Key? key, required this.articles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: articles.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final article = articles[index];
        return SavedArticleCard(
          title: article["title"] ?? '',
          thumbnailUrl: article["thumbnailUrl"] ?? '',
          description: article["description"] ?? '',
        );
      },
    );
  }
}

/// Widget untuk menampilkan satu artikel tersimpan.
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(
                title: title,
                thumbnailUrl: thumbnailUrl,
                description: description,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 6,
              ),
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
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 140,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image,
                            color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.text.withOpacity(0.7),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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

/// Halaman detail artikel.
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
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image,
                      color: Colors.grey, size: 50),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description,
              style: const TextStyle(
                  fontSize: 16, height: 1.5, color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }
}
