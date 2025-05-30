import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/search/search_item.dart';
import 'package:mediaexplant/features/search/search_repository.dart';
import 'package:mediaexplant/features/search/search_viewmodel.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchViewModel(SearchRepository()),
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
      final viewModel = context.read<SearchViewModel>();
      if (query.trim().isEmpty) {
        viewModel.cari(""); // bisa juga tambahkan metode clear kalau mau
        return;
      }
      viewModel.cari(query);
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
    final viewModel = context.watch<SearchViewModel>();

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
                hintText: 'Cari berita, produk, karya...',
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
              "Gunakan fitur pencarian ini untuk menemukan konten seperti berita, produk, atau karya. Ketik kata kunci, dan kami bantu carikan!",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const Divider(thickness: 1),

          if (_controller.text.trim().isNotEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Builder(
                  builder: (context) {
                    if (viewModel.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (viewModel.error != null) {
                      return Center(child: Text(viewModel.error!));
                    } else if (viewModel.hasil.isEmpty) {
                      return const Center(child: Text('Tidak ada hasil'));
                    } else {
                      return ListView.builder(
                        itemCount: viewModel.hasil.length,
                        itemBuilder: (context, index) {
                          final item = viewModel.hasil[index];
                          return SearchItem(hasil: item);
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
