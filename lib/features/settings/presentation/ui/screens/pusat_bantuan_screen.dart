import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart'; // Sesuaikan path jika diperlukan

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

/// Model data FAQ untuk menyimpan pertanyaan, jawaban, dan kategori.
class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}

/// Layar Hubungi Kami dengan form kontak yang lengkap dan fungsional.
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
                  if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white, // Mengubah warna font tombol menjadi putih.
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

/// Layar Pusat Bantuan (FAQ) dengan fitur pencarian, filter kategori, refresh, dan navigasi.
class PusatBantuanScreen extends StatefulWidget {
  const PusatBantuanScreen({super.key});

  @override
  _PusatBantuanScreenState createState() => _PusatBantuanScreenState();
}

class _PusatBantuanScreenState extends State<PusatBantuanScreen> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  String _selectedCategory = 'Semua';

  /// Daftar lengkap FAQ.
  final List<FAQItem> _allFAQs = [
    FAQItem(
      question: 'Bagaimana cara mendaftar akun?',
      answer:
          'Untuk mendaftar akun, klik tombol "Daftar" di halaman login dan isi formulir pendaftaran dengan data yang valid.',
      category: 'Akun',
    ),
    // Tambahkan FAQ lain sesuai kebutuhan.
  ];

  List<FAQItem> _filteredFAQs = [];
  final List<String> _categories = ['Semua', 'Akun', 'Teknis', 'Umum', 'Backup'];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _filteredFAQs = List.from(_allFAQs);
    _searchController.addListener(_filterFAQs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Filter FAQ berdasarkan pencarian dan kategori.
  void _filterFAQs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFAQs = _allFAQs.where((faq) {
        final matchesQuery = faq.question.toLowerCase().contains(query) ||
            faq.answer.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == 'Semua'
            ? true
            : faq.category == _selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  /// Simulasi refresh data FAQ.
  Future<void> _refreshFAQs() async {
    await Future.delayed(const Duration(seconds: 2));
    _filterFAQs();
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

Widget _buildCategoryDropdown() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: DropdownButtonHideUnderline( // Sembunyikan garis bawah dropdown
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: InputDecoration(
          labelText: 'Kategori',
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        items: _categories.map((cat) {
          return DropdownMenuItem<String>(
            value: cat,
            child: Text(cat),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _selectedCategory = newValue;
              _filterFAQs();
            });
          }
        },
      ),
    ),
  );
}


  /// Daftar FAQ dalam bentuk kartu dengan ExpansionTile.
  Widget _buildFAQList() {
    if (_filteredFAQs.isEmpty) {
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
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _filteredFAQs.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final faq = _filteredFAQs[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ExpansionTile(
            title: Text(
              faq.question,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  faq.answer,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Bantuan'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshFAQs,
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
              const SizedBox(height: 24),
Center(
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.pushNamed(context, '/hubungi');
    },
    // Hapus "const" dan tetapkan warna ikon secara eksplisit
    icon: const Icon(Icons.contact_support, color: Colors.white),
    label: const Text('Hubungi Tim Dukungan'),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white, // Mengatur warna teks dan ikon menjadi putih
    ),
  ),
),

              const SizedBox(height: 16),
            ],
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
      foregroundColor: Colors.white, // Mengatur warna teks dan ikon menjadi putih
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
