import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/search_viewmodel.dart';
import '../widgets/search_result_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<SearchViewModel>().search(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
              ),
              onSubmitted: (value) => _onSearch(),
            ),
            const SizedBox(height: 16),
            // Tampilan hasil pencarian
            if (viewModel.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (viewModel.error != null)
              Expanded(child: Center(child: Text(viewModel.error!)))
            else if (viewModel.results.isEmpty)
              const Expanded(child: Center(child: Text("No results found")))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.results.length,
                  itemBuilder: (context, index) {
                    final search = viewModel.results[index];
                    return SearchResultItem(search: search);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}