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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.fetchProfile(),
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.errorMessage != null
              ? Center(child: Text(viewModel.errorMessage!))
              : viewModel.profile == null
                  ? const Center(child: Text('No profile data'))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header profil dengan background gradasi
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    viewModel.profile!.avatarUrl,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  viewModel.profile!.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Section untuk saved articles
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Saved Articles',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // ListView dengan data dummy
                          ListView.builder(
                            padding: const EdgeInsets.all(12),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dummySavedArticles.length,
                            itemBuilder: (context, index) {
                              final article = dummySavedArticles[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading: Image.network(
                                    article["thumbnailUrl"]!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(article["title"]!),
                                  subtitle: Text(article["description"]!),
                                  onTap: () {
                                    // Navigasi ke detail artikel jika diperlukan
                                  },
                                ),
                              );
                            },
                          ),
                          // Tombol Settings
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/settings');
                              },
                              icon: const Icon(Icons.settings),
                              label: const Text('Settings'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}