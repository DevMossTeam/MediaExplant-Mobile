import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Main widget untuk tampilan profil dengan data dummy.
/// Tampilan akan berbeda jika pengguna sudah login atau belum.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  /// Dummy state login.
  /// Ubah nilai isLoggedIn ke true untuk mensimulasikan pengguna yang sudah login.
  final bool isLoggedIn = false;

  /// Data dummy untuk artikel tersimpan (hanya sebagai contoh).
  static const List<Map<String, String>> dummySavedArticles = [
    {
      "title": "Artikel Tersimpan 1",
      "thumbnailUrl": "https://via.placeholder.com/300x200",
      "description":
          "Deskripsi singkat artikel tersimpan 1 yang sangat menarik dan informatif.",
    },
    {
      "title": "Artikel Tersimpan 2",
      "thumbnailUrl": "https://via.placeholder.com/300x200",
      "description":
          "Deskripsi singkat artikel tersimpan 2 yang memberikan wawasan mendalam.",
    },
    {
      "title": "Artikel Tersimpan 3",
      "thumbnailUrl": "https://via.placeholder.com/300x200",
      "description":
          "Deskripsi singkat artikel tersimpan 3 dengan konten yang relevan.",
    },
    {
      "title": "Artikel Tersimpan 4",
      "thumbnailUrl": "https://via.placeholder.com/300x200",
      "description":
          "Deskripsi singkat artikel tersimpan 4 dengan informasi terkini.",
    },
    {
      "title": "Artikel Tersimpan 5",
      "thumbnailUrl": "https://via.placeholder.com/300x200",
      "description": "Deskripsi singkat artikel tersimpan 5 yang memukau.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Data profil dummy.
    final dummyProfile = {
      "name": "John Doe",
      "avatarUrl": "https://via.placeholder.com/150",
      "joinedDate": "Januari 2024",
    };

    return Scaffold(
      backgroundColor: Colors.grey[100],
      // Tombol Floating Action untuk navigasi ke halaman Settings,
      // selalu tampil dan ditempatkan secara eksplisit di pojok kanan bawah.
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 6,
        onPressed: () {
          Navigator.pushNamed(context, '/settings');
        },
        icon: const Icon(Icons.settings, color: Colors.white),
        label: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: isLoggedIn
          ? LoggedInProfileContent(
              profile: dummyProfile, articles: dummySavedArticles)
          : const NotLoggedInProfileContent(),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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

/// untuk menciptakan pengalaman visual yang lebih menarik.
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
    // Inisialisasi AnimationController dengan durasi 1200ms
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Animasi untuk avatar: fade in secara perlahan
    _avatarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Animasi untuk teks header: slide dari bawah ke posisi semula
    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Animasi untuk konten lainnya: fade in secara bersamaan
    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Memulai animasi secara otomatis ketika widget diinisialisasi
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Widget avatar yang diberi animasi fade in menggunakan Lottie animation
  Widget _buildAvatar() {
    return FadeTransition(
      opacity: _avatarFadeAnimation,
      child: ClipOval(
        child: Container(
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

  /// Widget teks header yang diberi animasi slide
  Widget _buildHeaderText() {
    return SlideTransition(
      position: _headerSlideAnimation,
      child: const Text(
        'Anda belum login',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0D47A1),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  /// Widget teks sub-header dengan keterangan dan ajakan yang lebih informatif
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

  /// Widget tombol login yang diberi animasi fade in
  Widget _buildLoginButton(BuildContext context) {
    return FadeTransition(
      opacity: _contentFadeAnimation,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () {
            // Navigasi ke halaman login saat tombol ditekan
            Navigator.pushNamed(context, '/login');
          },
          icon: const Icon(Icons.login, color: Colors.white),
          label: const Text(
            'Login',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D47A1),
            foregroundColor: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          ),
        ),
      ),
    );
  }

  /// Widget tambahan berupa tagline yang bersifat motivasional
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

  /// Widget untuk menampilkan background dengan efek gradient
  Widget _buildDecorativeBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.blue.shade50,
          ],
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
        // Background dekoratif
        _buildDecorativeBackground(),
        // Konten utama yang dapat discroll jika diperlukan
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

/// ProfileHeader membuat header profil yang menampilkan background gradient dan avatar.
class ProfileHeader extends StatelessWidget {
  final Map<String, String> profile;
  const ProfileHeader({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          double percentage = (constraints.maxHeight - kToolbarHeight) /
              (300 - kToolbarHeight);
          bool isCollapsed = percentage < 0.01;

          return FlexibleSpaceBar(
            centerTitle: true,
            title: null, // Jangan tampilkan judul saat collapse.
            background: isCollapsed
                ? const SizedBox.shrink() // Sembunyikan isi saat collapse.
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
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
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      NetworkImage(profile["avatarUrl"]!),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                profile["name"]!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 2,
                                      color: Colors.black45,
                                      offset: Offset(0, 1),
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

/// SectionTitle memberikan konsistensi tampilan judul antar bagian.
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D47A1),
          ),
    );
  }
}

/// SavedArticlesSection menampilkan daftar artikel tersimpan.
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

/// SavedArticleCard merepresentasikan satu artikel tersimpan dengan thumbnail, judul, dan deskripsi singkat.
/// Menggunakan animasi Hero untuk transisi yang halus.
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
          // Navigasi ke halaman detail artikel ketika kartu ditekan.
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
              // Gambar artikel dengan animasi Hero.
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
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Detail artikel: judul dan deskripsi singkat.
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
                        color: Color(0xFF0D47A1),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
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

/// Halaman detail artikel untuk menampilkan konten lengkap artikel yang dipilih.
/// Menggunakan animasi Hero untuk transisi gambar.
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      body: ListView(
        children: [
          // Gambar artikel dengan transisi Hero.
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
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 50,
                  ),
                );
              },
            ),
          ),
          // Konten deskripsi artikel.
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}