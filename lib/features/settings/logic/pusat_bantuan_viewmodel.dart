// lib/features/settings/logic/pusat_bantuan_viewmodel.dart

import 'package:flutter/foundation.dart';

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

/// ViewModel untuk Pusat Bantuan (FAQ).
/// Menyimpan daftar FAQ, state pencarian & kategori, serta logic filtering, refresh, dan pagination.
class PusatBantuanViewModel extends ChangeNotifier {
  // Daftar lengkap FAQ (hard-coded, bisa diganti dengan fetch dari server).
  final List<FAQItem> _allFAQs = [
    // Kategori: Akun
    FAQItem(
      question: "Bagaimana cara mendaftar akun?",
      answer:
          "Untuk mendaftar akun, tekan tombol “Daftar” pada halaman login. Isi nama lengkap, alamat email, dan password, lalu verifikasi melalui tautan yang dikirim ke email Anda.",
      category: "Akun",
    ),
    FAQItem(
      question: "Saya lupa password, bagaimana cara meresetnya?",
      answer:
          "Pada halaman login, klik “Lupa Password”. Masukkan email terdaftar, kemudian ikuti petunjuk yang dikirim via email untuk membuat password baru.",
      category: "Akun",
    ),
    FAQItem(
      question: "Bisakah saya mengganti username setelah mendaftar?",
      answer:
          "Untuk saat ini, fitur mengganti username belum tersedia. Anda bisa menghubungi tim dukungan (support@contohapp.com) jika benar-benar perlu bantuan.",
      category: "Akun",
    ),

    // Kategori: Berita
    FAQItem(
      question: "Bagaimana cara mencari dan membaca berita terbaru?",
      answer:
          "Setelah login, pada halaman beranda Anda akan melihat daftar berita terbaru. Gunakan kolom pencarian di atas untuk memfilter berdasarkan kata kunci, kategori, atau tanggal publikasi.",
      category: "Berita",
    ),
    FAQItem(
      question: "Apakah saya bisa menyimpan berita untuk dibaca nanti?",
      answer:
          "Ya, cukup tekan ikon bookmark (★) pada setiap judul berita. Berita yang di-bookmark akan tersimpan di menu “Favorit” untuk dibaca kapan-pun.",
      category: "Berita",
    ),
    FAQItem(
      question: "Bagaimana cara mengaktifkan notifikasi berita?",
      answer:
          "Masuk ke Settings → Notifikasi → Aktifkan “Notifikasi Berita Baru”. Anda akan mendapatkan push notification ketika ada berita terbaru yang terbit.",
      category: "Berita",
    ),

    // Kategori: Karya (syair, pantun, puisi, desain grafis, fotografi)
    FAQItem(
      question: "Bagaimana cara mengirim karya syair, pantun, atau puisi?",
      answer:
          "Di menu “Karya”, pilih submenu “Kirim Karya” → “Teks”. Isi judul, kategori (misal: Syair/Pantun/Puisi), lalu lampirkan file .txt atau langsung tulis di kolom yang disediakan. Setelah itu, tekan “Kirim”.",
      category: "Karya",
    ),
    FAQItem(
      question: "Apa saja format file yang diterima untuk karya desain grafis?",
      answer:
          "Untuk karya desain grafis, kami mendukung format JPEG, PNG, dan SVG dengan ukuran maksimal 5 MB per file. Pastikan resolusi minimal 1080×1080 piksel.",
      category: "Karya",
    ),
    FAQItem(
      question: "Bagaimana saya dapat mengunggah koleksi fotografi?",
      answer:
          "Pilih menu “Karya” → “Karya Foto”. Tekan tombol “Unggah Foto” dan pilih beberapa gambar dari galeri. Setelah diunggah, tambahkan judul, deskripsi singkat, serta tag lokasi jika perlu.",
      category: "Karya",
    ),
    FAQItem(
      question: "Apakah karya saya bisa dikomentari oleh pengguna lain?",
      answer:
          "Ya. Setelah karya Anda diterbitkan, pengguna lain dapat memberi komentar dan like. Anda juga bisa membalas komentar langsung dari halaman karya Anda.",
      category: "Karya",
    ),
    FAQItem(
      question: "Bagaimana cara mengedit atau menghapus karya yang sudah dikirim?",
      answer:
          "Masuk ke halaman profil Anda → pilih “Karya Saya”. Di masing-masing item akan ada ikon edit (✏️) dan hapus (🗑️). Ketuk sesuai kebutuhan, lalu simpan perubahan.",
      category: "Karya",
    ),

    // Kategori: Produk (buletin, majalah)
    FAQItem(
      question: "Apa itu Buletin dan Majalah di aplikasi ini?",
      answer:
          "Buletin adalah koleksi artikel pendek yang terbit secara berkala (misal: mingguan). Majalah adalah terbitan khusus dengan artikel mendalam, foto-foto eksklusif, dan desain khusus.",
      category: "Produk",
    ),
    FAQItem(
      question: "Bagaimana cara mengakses Buletin terbaru?",
      answer:
          "Pergi ke menu “Produk” → pilih “Buletin”. Scroll ke bawah untuk daftar edisi. Tekan edisi yang diinginkan, lalu tap “Buka” untuk membaca.",
      category: "Produk",
    ),
    FAQItem(
      question: "Apakah saya perlu berlangganan untuk membaca Majalah?",
      answer:
          "Tidak. Semua edisi Majalah tersedia secara gratis di aplikasi ini. Cukup kunjungi menu “Produk” → “Majalah” → pilih edisi yang ingin dibaca.",
      category: "Produk",
    ),
    FAQItem(
      question: "Bisakah saya mengunduh Buletin atau Majalah untuk dibaca offline?",
      answer:
          "Ya. Setelah memilih edisi Buletin/Majalah, tekan ikon unduh (⬇️). File akan tersimpan di folder “Download” aplikasi untuk dibaca tanpa koneksi internet.",
      category: "Produk",
    ),

    // Kategori: Teknis
    FAQItem(
      question: "Aplikasi sering force close, apa yang harus saya lakukan?",
      answer:
          "Coba perbarui aplikasi ke versi terbaru di Play Store/App Store. Jika masih bermasalah, clear cache melalui Settings → Aplikasi → [Nama Aplikasi] → Penyimpanan → Hapus Cache, lalu restart perangkat.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Kenapa gambar di artikel tidak muncul?",
      answer:
          "Pastikan koneksi internet Anda stabil. Jika masih kosong, coba refresh halaman dengan menarik layar ke bawah (pull-to-refresh). Jika tidak berhasil, bisa jadi server sedang bermasalah—silakan coba lagi beberapa saat.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Bagaimana cara mengubah bahasa tampilan aplikasi?",
      answer:
          "Masuk ke Settings → Bahasa & Wilayah → pilih bahasa yang diinginkan. Aplikasi akan otomatis restart dan tampil dalam bahasa pilihan.",
      category: "Teknis",
    ),

    // Kategori: Umum
    FAQItem(
      question: "Apakah aplikasi ini berbayar?",
      answer:
          "Tidak. Seluruh konten berita, karya, buletin, dan majalah dapat diakses secara gratis tanpa biaya langganan maupun pembelian in-app.",
      category: "Umum",
    ),
    FAQItem(
      question: "Bagaimana cara menghubungi tim redaksi atau dukungan?",
      answer:
          "Kirim email ke devmoss@gmail.com atau kunjungi menu “Bantuan & Kontak” → “Hubungi Kami” di aplikasi. Anda bisa memilih kategori: Pertanyaan Teknis, Saran Konten, atau Kolaborasi.",
      category: "Umum",
    ),
    FAQItem(
      question: "Apakah saya bisa berkontribusi menjadi penulis lepas?",
      answer:
          "Tentu. Buka halaman “Bantuan & Kontak” → pilih “Daftar Penulis Lepas”. Isi formulir singkat, lampirkan portofolio, dan tim redaksi akan menghubungi Anda jika memenuhi syarat.",
      category: "Umum",
    ),
    FAQItem(
      question: "Bagaimana kebijakan privasi dan syarat ketentuan aplikasi ini?",
      answer:
          "Anda bisa membaca secara lengkap di Settings → Tentang → Kebijakan Privasi & Syarat Ketentuan. Dokumen ini menjelaskan hak dan kewajiban pengguna serta penanganan data pribadi.",
      category: "Umum",
    ),
  ];

  // State untuk daftar FAQ yang sudah difilter (awal = semua FAQ).
  List<FAQItem> _filteredFAQs = [];

  // Daftar kategori yang ditampilkan di dropdown.
  final List<String> categories = [
    'Semua',
    'Akun',
    'Berita',
    'Karya',
    'Produk',
    'Teknis',
    'Umum',
  ];

  // State untuk pencarian (search query) dan kategori yang dipilih.
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  // State untuk pagination: berapa item yang saat ini akan ditampilkan.
  int _itemsToDisplay = 5;

  PusatBantuanViewModel() {
    // Inisialisasi filteredFAQs = allFAQs di awal, lalu notify untuk membangun UI.
    _filteredFAQs = List.from(_allFAQs);
  }

  /// Getter untuk daftar FAQ hasil filter secara penuh (tanpa pagination).
  List<FAQItem> get filteredFAQs => List.unmodifiable(_filteredFAQs);

  /// Getter untuk daftar FAQ hasil filter & pagination (hanya mengambil _itemsToDisplay item pertama).
  List<FAQItem> get paginatedFAQs {
    final count = _itemsToDisplay < _filteredFAQs.length
        ? _itemsToDisplay
        : _filteredFAQs.length;
    return _filteredFAQs.take(count).toList();
  }

  /// Apakah masih ada FAQ tersisa untuk dimuat (bila ingin menampilkan indikator loading)?
  bool get canLoadMore => _itemsToDisplay < _filteredFAQs.length;

  /// Getter untuk kategori yang sedang dipilih.
  String get selectedCategory => _selectedCategory;

  /// Getter untuk search query (jika ingin diakses dari UI).
  String get searchQuery => _searchQuery;

  /// Jumlah total FAQ hasil filter (bisa dipakai untuk menampilkan “X hasil ditemukan”).
  int get totalFilteredCount => _filteredFAQs.length;

  /// Update search query dan langsung memanggil filter + reset pagination.
  void setSearchQuery(String newQuery) {
    _searchQuery = newQuery.toLowerCase();
    _filterFAQs(resetPagination: true);
  }

  /// Update kategori yang dipilih dan langsung memanggil filter + reset pagination.
  void setSelectedCategory(String newCategory) {
    _selectedCategory = newCategory;
    _filterFAQs(resetPagination: true);
  }

  /// Logika filtering: kombinasi antara kata kunci dan kategori.
  /// Jika [resetPagination] = true, maka _itemsToDisplay kembali ke nilai awal (5).
  void _filterFAQs({bool resetPagination = false}) {
    _filteredFAQs = _allFAQs.where((faq) {
      final matchesQuery = faq.question.toLowerCase().contains(_searchQuery) ||
          faq.answer.toLowerCase().contains(_searchQuery);
      final matchesCategory = (_selectedCategory == 'Semua')
          ? true
          : faq.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();

    if (resetPagination) {
      _itemsToDisplay = 5;
    }
    notifyListeners();
  }

  /// Simulasi refresh data FAQ (misalnya jika ingin mengambil ulang dari server).
  /// Setelah refresh, filter dijalankan ulang dan pagination di-reset.
  Future<void> refreshFAQs() async {
    // Contoh simulasi delay jaringan:
    await Future.delayed(const Duration(seconds: 2));

    // Jika ingin ambil ulang dari backend, letakkan di sini:
    // _allFAQs = await repository.fetchFAQs();
    // Lalu jalankan _filterFAQs(resetPagination: true);

    _filterFAQs(resetPagination: true);
  }

  /// Tambah jumlah item yang akan ditampilkan (dipanggil saat infinite scroll).
  /// Menaikkan _itemsToDisplay sebanyak 5, tapi tidak lebih dari panjang _filteredFAQs.
  void loadMoreFAQs() {
    if (_itemsToDisplay < _filteredFAQs.length) {
      _itemsToDisplay = (_itemsToDisplay + 5) < _filteredFAQs.length
          ? (_itemsToDisplay + 5)
          : _filteredFAQs.length;
      notifyListeners();
    }
  }
}
