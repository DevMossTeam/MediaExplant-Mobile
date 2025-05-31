import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/settings/logic/pusat_bantuan_viewmodel.dart'; // Import ViewModel

void main() {
  runApp(const MyApp());
}

/// Widget utama aplikasi dengan konfigurasi tema dan routing.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pusat Bantuan - Help Center',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Gunakan textTheme yang bersih dan modern.
        textTheme: const TextTheme(
          bodySmall: TextStyle(fontSize: 16, color: AppColors.text),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PusatBantuanScreen(),
        '/hubungi': (context) => const HubungiKamiScreen(),
      },
    );
  }
}

/// Layar Hubungi Kami dengan form kontak yang lengkap dan fungsional.
/// (Tidak diubah—tetap sama seperti sebelumnya.)
class HubungiKamiScreen extends StatefulWidget {
  const HubungiKamiScreen({super.key});

  @override
  State<HubungiKamiScreen> createState() => _HubungiKamiScreenState();
}

class _HubungiKamiScreenState extends State<HubungiKamiScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller untuk masing-masing field.
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// Fungsi untuk memproses pengiriman pesan.
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pesan terkirim!")),
      );
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hubungi Kami'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Hubungi Tim Dukungan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 16),
              // Field untuk Nama.
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Field untuk Email.
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$')
                      .hasMatch(value)) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Field untuk Pesan.
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'Pesan',
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Pesan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Tombol kirim.
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white, // Warna font tombol putih.
                ),
                child: const Text(
                  'Kirim Pesan',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Layar Pusat Bantuan (FAQ) yang sekarang menggunakan ViewModel.
/// Ditambahkan infinite scroll untuk memuat 5 item per batch,
/// dan indikator loading saat memuat lebih banyak item.
class PusatBantuanScreen extends StatefulWidget {
  const PusatBantuanScreen({super.key});

  @override
  _PusatBantuanScreenState createState() => _PusatBantuanScreenState();
}

class _PusatBantuanScreenState extends State<PusatBantuanScreen> {
  // 1) Instance ViewModel
  late PusatBantuanViewModel viewModel;

  // 2) Controller untuk TextField pencarian
  late TextEditingController _searchController;

  // 3) ScrollController untuk mendeteksi scroll
  late ScrollController _scrollController;

  // 4) Jumlah item yang saat ini ditampilkan (untuk pagination)
  int _itemsToDisplay = 5;

  // 5) State loading saat memuat lebih banyak item
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi ViewModel
    viewModel = PusatBantuanViewModel();
    viewModel.addListener(() {
      // Reset jumlah item saat data/hasil filter berubah
      setState(() {
        _itemsToDisplay = 5;
      });
    });

    _searchController = TextEditingController();
    _searchController.addListener(() {
      viewModel.setSearchQuery(_searchController.text);
    });

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    viewModel.removeListener(() {});
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Header dengan judul dan deskripsi.
  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Butuh Bantuan?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Cari jawaban dari pertanyaan yang sering diajukan atau hubungi tim dukungan kami.',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  /// Kolom pencarian.
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari bantuan...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    // Mengosongkan pencarian juga akan memicu listener dan ViewModel.setSearchQuery('')
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// Dropdown kategori, memanggil viewModel.setSelectedCategory saat berubah.
  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: viewModel.selectedCategory,
          decoration: InputDecoration(
            labelText: 'Kategori',
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          items: viewModel.categories.map((cat) {
            return DropdownMenuItem<String>(
              value: cat,
              child: Text(cat),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              viewModel.setSelectedCategory(newValue);
            }
          },
        ),
      ),
    );
  }

  /// Daftar FAQ dalam bentuk kartu dengan ExpansionTile, hanya menampilkan batch sesuai _itemsToDisplay.
  Widget _buildFAQList() {
    final allFaqs = viewModel.filteredFAQs;

    if (allFaqs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'Maaf, tidak ada FAQ yang sesuai dengan pencarian Anda.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
      );
    }

    // Tentukan berapa banyak item yang akan ditampilkan saat ini
    final displayCount = _itemsToDisplay < allFaqs.length
        ? _itemsToDisplay
        : allFaqs.length;
    final displayedFaqs = allFaqs.take(displayCount).toList();

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: displayedFaqs.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final faq = displayedFaqs[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ExpansionTile(
            title: Text(
              faq.question,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  faq.answer,
                  style:
                      const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Fungsi untuk menambah jumlah item saat mencapai bagian bawah secara asynchronous.
  void _maybeLoadMore() {
    final totalFaqs = viewModel.filteredFAQs.length;
    if (!_isLoadingMore && _itemsToDisplay < totalFaqs) {
      setState(() {
        _isLoadingMore = true; // Mulai loading
      });

      // Simulasi delay untuk memuat lebih banyak data (bisa diganti fetch API).
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _itemsToDisplay = (_itemsToDisplay + 5) < totalFaqs
              ? (_itemsToDisplay + 5)
              : totalFaqs;
          _isLoadingMore = false; // Selesai loading
        });
      });
    }
  }

  /// Listener scroll mengawasi apakah sudah mencapai ujung bawah.
  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 100) {
      _maybeLoadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Bantuan'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await viewModel.refreshFAQs();
          // Setelah refresh, reset jumlah item
          setState(() {
            _itemsToDisplay = 5;
          });
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildSearchBar(),
                const SizedBox(height: 8),
                _buildCategoryDropdown(),
                const SizedBox(height: 24),
                const Text(
                  'Pertanyaan yang Sering Diajukan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFAQList(),
                const SizedBox(height: 16),
                // Tampilkan indikator loading di bawah jika sedang memuat lebih banyak item
                if (_isLoadingMore)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
