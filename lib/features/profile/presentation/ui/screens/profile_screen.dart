import 'package:flutter/material.dart';

/// Main widget untuk tampilan profil dengan data dummy.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
      // Tombol Floating Action untuk navigasi ke halaman Settings.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/settings');
        },
        icon: const Icon(Icons.settings),
        label: const Text('Settings'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header profil dengan tampilan gradient dan avatar.
            ProfileHeader(profile: dummyProfile),
            // Konten utama profil dan artikel tersimpan.
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul section untuk artikel tersimpan.
                    const SectionTitle(title: 'Saved Articles'),
                    const SizedBox(height: 12),
                    // Daftar artikel tersimpan yang ditampilkan secara horizontal.
                    SavedArticlesSection(articles: dummySavedArticles),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget header profil yang menggunakan SliverAppBar dengan background gradient,
/// menampilkan nama dan avatar pengguna dengan animasi Hero.
class ProfileHeader extends StatelessWidget {
  final Map<String, String> profile;
  const ProfileHeader({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        // Hapus atau komentar baris berikut untuk menghilangkan judul di AppBar
        // title: Text(
        //   profile["name"]!,
        //   style: const TextStyle(
        //     fontSize: 16,
        //     color: Colors.white,
        //     shadows: [
        //       Shadow(
        //         blurRadius: 2,
        //         color: Colors.black45,
        //         offset: Offset(0, 1),
        //       )
        //     ],
        //   ),
        // ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background gradient.
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Tampilan avatar dan nama profil.
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
                        backgroundImage: NetworkImage(profile["avatarUrl"]!),
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
      ),
    );
  }
}

/// Widget untuk menampilkan statistik profil secara individual.
class ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  const ProfileStat({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

/// Widget judul section untuk memberikan konsistensi tampilan antar bagian.
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
    );
  }
}

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
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar artikel dengan animasi Hero.
              Hero(
                tag: thumbnailUrl,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
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
                        child:
                            const Icon(Icons.broken_image, color: Colors.grey),
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
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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
        backgroundColor: Colors.blue[800],
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
                  child: const Icon(Icons.broken_image,
                      color: Colors.grey, size: 50),
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
