import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/profile_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Data dummy untuk saved articles
  static const List<Map<String, String>> dummySavedArticles = [
    {
      "title": "Saved News 1",
      "thumbnailUrl": "https://via.placeholder.com/80",
      "description": "This is a short description of saved news 1.",
    },
    {
      "title": "Saved News 2",
      "thumbnailUrl": "https://via.placeholder.com/80",
      "description": "This is a short description of saved news 2.",
    },
    {
      "title": "Saved News 3",
      "thumbnailUrl": "https://via.placeholder.com/80",
      "description": "This is a short description of saved news 3.",
    },
    {
      "title": "Saved News 4",
      "thumbnailUrl": "https://via.placeholder.com/80",
      "description": "This is a short description of saved news 4.",
    },
    {
      "title": "Saved News 5",
      "thumbnailUrl": "https://via.placeholder.com/80",
      "description": "This is a short description of saved news 5.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    if (viewModel.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (viewModel.errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(viewModel.errorMessage!)),
      );
    }

    if (viewModel.profile == null) {
      return const Scaffold(
        body: Center(child: Text('No profile data')),
      );
    }

    final profile = viewModel.profile!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header dengan SliverAppBar menyerupai cover profile
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                profile.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Latar belakang dengan gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Overlay untuk avatar (ditempatkan di bagian bawah)
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(profile.avatarUrl),
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          profile.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        // Tambahan info seperti username atau stats bisa ditambahkan di sini
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Konten profil di bawah header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contoh row untuk statistik (mirip Reddit)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem("Karma", "1.2k"),
                      _buildStatItem("Cake Day", "Jan 2020"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Section untuk Saved Articles
                  Text(
                    'Saved Articles',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: dummySavedArticles.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final article = dummySavedArticles[index];
                        return Container(
                          width: 220,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: Image.network(
                                  article["thumbnailUrl"]!,
                                  width: 80,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article["title"]!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        article["description"]!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Tombol untuk membuka halaman Settings
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text('Settings'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}