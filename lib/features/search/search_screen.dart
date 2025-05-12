import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_populer_item.dart';
import 'package:mediaexplant/features/search/search_viewmodel.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchBeritaViewModel(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) return;
      final viewModel = context.read<SearchBeritaViewModel>();
      viewModel.searchBerita(query: query, userId: "4FUD7QhJ0hMLMMlF6VQHjvkXad4L");
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchBeritaViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15, top: 5),
          child: Image.asset('assets/images/app_logo.png'),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _controller,
              onChanged: _onSearch,
              decoration: const InputDecoration(
                hintText: 'Cari berita...',
                border: InputBorder.none,
                suffixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              "Gunakan fitur pencarian ini untuk menemukan konten berita yang kamu butuhkan. Cukup ketik kata kuncinya, dan biar kami bantu carikan!",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const Divider(thickness: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Builder(
                builder: (context) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (viewModel.errorMessage != null) {
                    return Center(child: Text(viewModel.errorMessage!));
                  } else if (viewModel.hasilPencarian.isEmpty) {
                    return const Center(
                      child: Text(
                          'Tidak ada hasil'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: viewModel.hasilPencarian.length,
                      itemBuilder: (context, index) {
                        final berita = viewModel.hasilPencarian[index];
                        return ChangeNotifierProvider.value(
                          value: berita,
                          child: const BeritaPopulerItem(),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
