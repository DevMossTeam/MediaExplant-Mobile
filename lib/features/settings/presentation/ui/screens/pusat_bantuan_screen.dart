import 'package:flutter/material.dart';

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
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
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

/// Model data untuk menyimpan FAQ.
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

/// Layar Hubungi Kami sebagai placeholder untuk route '/hubungi'.
class HubungiKamiScreen extends StatelessWidget {
  const HubungiKamiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hubungi Kami'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Halaman Hubungi Kami',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Di halaman ini, Anda dapat menemukan informasi kontak dan formulir untuk menghubungi tim dukungan kami.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Layar Pusat Bantuan yang sangat lengkap dengan fitur pencarian, filter kategori, refresh, dan navigasi.
class PusatBantuanScreen extends StatefulWidget {
  const PusatBantuanScreen({super.key});

  @override
  _PusatBantuanScreenState createState() => _PusatBantuanScreenState();
}

class _PusatBantuanScreenState extends State<PusatBantuanScreen> {
  late TextEditingController _searchController;
  String _selectedCategory = 'Semua';

  /// Daftar lengkap FAQ dengan kategori masing-masing.
  final List<FAQItem> _allFAQs = [
    FAQItem(
      question: 'Bagaimana cara mendaftar akun?',
      answer:
          'Untuk mendaftar akun, klik tombol "Daftar" di halaman login dan isi formulir pendaftaran dengan data yang valid.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara mereset password?',
      answer:
          'Jika Anda lupa password, klik "Lupa Password?" di halaman login dan ikuti instruksi untuk mereset password melalui email.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara mengubah profil saya?',
      answer:
          'Anda dapat mengubah informasi profil melalui menu "Profil" di dalam aplikasi, lalu pilih "Edit Profil" untuk menyimpan perubahan.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Apa yang harus dilakukan jika aplikasi error?',
      answer:
          'Cobalah untuk merestart aplikasi. Jika error masih terjadi, hubungi tim dukungan melalui halaman "Hubungi Kami".',
      category: 'Teknis',
    ),
    FAQItem(
      question: 'Bagaimana cara menghubungi tim support?',
      answer:
          'Anda dapat menghubungi tim support melalui halaman "Hubungi Kami" atau mengirim email ke support@aplikasi.com.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara melakukan pembayaran?',
      answer:
          'Pembayaran dapat dilakukan melalui menu "Pembayaran" di aplikasi dengan mengikuti instruksi yang tersedia.',
      category: 'Pembayaran',
    ),
    FAQItem(
      question: 'Apa metode pembayaran yang diterima?',
      answer:
          'Kami menerima berbagai metode pembayaran seperti kartu kredit, debit, dan transfer bank.',
      category: 'Pembayaran',
    ),
    FAQItem(
      question: 'Bagaimana cara mengupdate aplikasi?',
      answer:
          'Pastikan aplikasi Anda selalu terupdate dengan mengunjungi Play Store atau App Store dan mengunduh versi terbaru.',
      category: 'Teknis',
    ),
    FAQItem(
      question: 'Apakah data saya aman?',
      answer:
          'Kami menerapkan protokol keamanan yang ketat untuk melindungi data pengguna. Informasi lebih lanjut dapat dilihat di Kebijakan Privasi kami.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara menggunakan fitur terbaru?',
      answer:
          'Fitur terbaru biasanya disertai panduan penggunaan di dalam aplikasi. Silakan cek bagian Pengumuman atau Blog kami.',
      category: 'Umum',
    ),
  ];

  List<FAQItem> _filteredFAQs = [];

  /// Daftar kategori untuk filter.
  final List<String> _categories = ['Semua', 'Akun', 'Teknis', 'Pembayaran', 'Umum'];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredFAQs = List.from(_allFAQs);
    _searchController.addListener(_filterFAQs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Fungsi untuk memfilter FAQ berdasarkan query pencarian dan kategori.
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

  /// Fungsi untuk menyimulasikan refresh data FAQ.
  Future<void> _refreshFAQs() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _filteredFAQs = _allFAQs.where((faq) {
        final query = _searchController.text.toLowerCase();
        final matchesQuery = faq.question.toLowerCase().contains(query) ||
            faq.answer.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == 'Semua'
            ? true
            : faq.category == _selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  /// Widget header untuk tampilan awal.
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Butuh Bantuan?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Cari jawaban dari pertanyaan yang sering diajukan atau hubungi tim dukungan kami.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  /// Widget untuk kolom pencarian.
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// Widget untuk dropdown filter kategori.
  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Kategori',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
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
    );
  }

  /// Widget untuk menampilkan daftar FAQ.
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
        return ExpansionTile(
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildFAQList(),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/hubungi');
                  },
                  icon: const Icon(Icons.contact_support),
                  label: const Text('Hubungi Tim Dukungan'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
          // Scroll ke atas
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}