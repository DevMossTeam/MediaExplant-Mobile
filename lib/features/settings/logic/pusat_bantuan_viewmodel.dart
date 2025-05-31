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
FAQItem(
      question: "Bagaimana cara mendaftar akun?",
      answer:
          "Untuk mendaftar akun, klik tombol \"Daftar\" di halaman login dan isi formulir pendaftaran dengan data yang valid.",
      category: "Akun",
    ),
    FAQItem(
      question: "Bagaimana cara mereset password?",
      answer:
          "Untuk mereset password, klik \"Lupa Password?\" di halaman login dan ikuti instruksi yang dikirim ke email Anda.",
      category: "Akun",
    ),
    FAQItem(
      question: "Mengapa aplikasi tidak bisa memuat data?",
      answer:
          "Pastikan koneksi internet Anda stabil dan coba tarik layar ke bawah untuk refresh.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Bagaimana cara backup data secara berkala?",
      answer:
          "Data akan terbackup otomatis setiap malam. Anda juga bisa klik Setting → Backup Sekarang.",
      category: "Backup",
    ),
    FAQItem(
      question: "Apakah ada batasan ukuran file yang bisa diunggah?",
      answer:
          "Batas maksimal ukuran file adalah 10 MB per file. Untuk ukuran lebih besar, silakan hubungi tim dukungan.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Di mana saya bisa melihat riwayat transaksi?",
      answer:
          "Riwayat transaksi dapat dilihat di menu Profil → Riwayat Transaksi.",
      category: "Umum",
    ),
    FAQItem(
      question: "Bagaimana cara mengubah profil saya?",
      answer:
          "Anda dapat mengubah informasi profil di menu Profil → Edit Profil.",
      category: "Akun",
    ),
    FAQItem(
      question: "Bagaimana cara menghapus akun saya?",
      answer:
          "Untuk menghapus akun, buka Pengaturan → Akun → Hapus Akun dan ikuti instruksi.",
      category: "Akun",
    ),
    FAQItem(
      question: "Apakah aplikasi tersedia di iOS?",
      answer:
          "Ya, Anda dapat mengunduh aplikasi di App Store untuk perangkat iOS.",
      category: "Umum",
    ),
    FAQItem(
      question: "Bagaimana cara mengaktifkan notifikasi push?",
      answer:
          "Anda dapat mengaktifkan notifikasi di Pengaturan → Notifikasi → Aktifkan Push Notifications.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Mengapa saya tidak menerima email verifikasi?",
      answer:
          "Pastikan email yang Anda masukkan benar dan periksa folder spam.",
      category: "Akun",
    ),
    FAQItem(
      question: "Bagaimana cara mengganti password?",
      answer:
          "Buka Pengaturan → Keamanan → Ganti Password dan ikuti instruksi.",
      category: "Akun",
    ),
    FAQItem(
      question: "Bagaimana cara melaporkan bug?",
      answer:
          "Gunakan menu Hubungi Kami → Kirim Laporan Bug dengan detail permasalahan.",
      category: "Umum",
    ),
    FAQItem(
      question: "Mengapa upload file berhenti di tengah?",
      answer:
          "Cek koneksi internet dan pastikan ukuran file tidak melebihi batas.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Bagaimana cara melihat tutorial penggunaan?",
      answer:
          "Buka menu Bantuan → Tutorial untuk melihat panduan lengkap.",
      category: "Umum",
    ),
    FAQItem(
      question: "Apa itu mode offline?",
      answer:
          "Mode offline memungkinkan Anda mengakses data yang sudah diunduh tanpa koneksi internet.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Bagaimana cara sinkronisasi data?",
      answer:
          "Data akan disinkronisasi otomatis saat Anda terhubung ke internet.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Apakah ada aplikasi desktop?",
      answer:
          "Saat ini kami belum menyediakan aplikasi desktop resmi.",
      category: "Umum",
    ),
    FAQItem(
      question: "Bagaimana cara mengatur bahasa aplikasi?",
      answer:
          "Buka Pengaturan → Bahasa dan pilih bahasa yang diinginkan.",
      category: "Umum",
    ),
    FAQItem(
      question: "Mengapa aplikasi sering keluar tiba-tiba?",
      answer:
          "Coba update aplikasi ke versi terbaru atau bersihkan cache di Pengaturan → Aplikasi.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Bagaimana cara menghubungkan ke akun Google?",
      answer:
          "Gunakan opsi Login dengan Google di halaman login utama.",
      category: "Akun",
    ),
    FAQItem(
      question: "Bagaimana cara mengganti foto profil?",
      answer:
          "Di Profil, klik ikon kamera pada foto profil untuk memilih gambar baru.",
      category: "Akun",
    ),
    FAQItem(
      question: "Apakah aplikasi mendukung dark mode?",
      answer:
          "Ya, buka Pengaturan → Tampilan → Dark Mode untuk mengaktifkan.",
      category: "Umum",
    ),
    FAQItem(
      question: "Bagaimana cara melihat notifikasi lama?",
      answer:
          "Notifikasi lama dapat dilihat di menu Notifikasi → Riwayat Notifikasi.",
      category: "Umum",
    ),
    FAQItem(
      question: "Apa kegunaan fitur backup manual?",
      answer:
          "Backup manual memungkinkan Anda menyimpan data setiap kali ditekan.",
      category: "Backup",
    ),
    FAQItem(
      question: "Bagaimana cara memulihkan data dari backup?",
      answer:
          "Buka Pengaturan → Backup & Restore → Pulihkan Data.",
      category: "Backup",
    ),
    FAQItem(
      question: "Apakah data terenkripsi di server?",
      answer:
          "Ya, semua data disimpan dengan enkripsi AES-256 di server kami.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Bagaimana cara mengubah metode pembayaran?",
      answer:
          "Buka Pengaturan → Pembayaran → Kelola Metode Pembayaran.",
      category: "Umum",
    ),
    FAQItem(
      question: "Apakah tersedia mode premium?",
      answer:
          "Ya, Anda dapat berlangganan premium melalui menu Profil → Berlangganan.",
      category: "Umum",
    ),
    FAQItem(
      question: "Bagaimana cara membatalkan langganan?",
      answer:
          "Buka Profil → Berlangganan → Batalkan Langganan.",
      category: "Umum",
    ),
    FAQItem(
      question: "Apakah ada batas jumlah backup?",
      answer:
          "Unlimited, Anda dapat backup kapan saja tanpa batas.",
      category: "Backup",
    ),
    FAQItem(
      question: "Bagaimana cara mengatur notifikasi email?",
      answer:
          "Buka Pengaturan → Notifikasi → Email Notifications dan atur preferensi.",
      category: "Umum",
    ),
    FAQItem(
      question: "Mengapa notifikasi tidak muncul?",
      answer:
          "Pastikan Anda sudah memberikan izin notifikasi di pengaturan perangkat.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Bagaimana cara export data ke CSV?",
      answer:
          "Buka menu Profil → Ekspor Data, pilih format CSV.",
      category: "Umum",
    ),
    FAQItem(
      question: "Apakah aplikasi mendukung multi-akun?",
      answer:
          "Saat ini fitur multi-akun belum tersedia.",
      category: "Umum",
    ),
    FAQItem(
      question: "Bagaimana cara mengatur batas waktu sesi?",
      answer:
          "Buka Pengaturan → Keamanan → Timeout Sesi dan atur durasi.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Bagaimana cara menambahkan kontak?",
      answer:
          "Buka menu Kontak → Tambah Kontak dan isi data.",
      category: "Akun",
    ),
    FAQItem(
      question: "Apa yang harus dilakukan jika lupa username?",
      answer:
          "Hubungi tim dukungan melalui menu Hubungi Kami.",
      category: "Akun",
    ),
    FAQItem(
      question: "Bagaimana cara menghapus cache aplikasi?",
      answer:
          "Buka Pengaturan → Aplikasi → Hapus Cache.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Bagaimana cara melihat versi aplikasi?",
      answer:
          "Buka Pengaturan → Tentang Aplikasi untuk melihat versi saat ini.",
      category: "Umum",
    ),
    FAQItem(
      question: "Bagaimana cara sharing file dengan pengguna lain?",
      answer:
          "Pilih file, lalu klik ikon bagikan dan pilih kontak tujuan.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Apakah koneksi HTTPS aman?",
      answer:
          "Ya, semua komunikasi melalui HTTPS terenkripsi.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Bagaimana cara menghubungkan API eksternal?",
      answer:
          "Gunakan API Key dari Pengaturan → Integrasi API.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Apa itu limit API harian?",
      answer:
          "Anda dapat melakukan maksimal 1000 permintaan per hari.",
      category: "Teknis",
    ),
    FAQItem(
      question: "Bagaimana cara melihat log aktivitas?",
      answer:
          "Buka menu Profil → Log Aktivitas untuk melihat riwayat.",
      category: "Umum",
    ),
    FAQItem(
      question: "Apa saja metode pembayaran yang didukung?",
      answer:
          "Kami mendukung kartu kredit, debit, dan e-wallet.",
      category: "Umum",
    ),
    FAQItem(
      question: "Bagaimana cara mengatur timezone?",
      answer:
          "Buka Pengaturan → Umum → Timezone dan pilih wilayah Anda.",
      category: "Umum",
    ),
    FAQItem(
      question: "Bagaimana cara mencadangkan chat?",
      answer:
          "Buka Chat → Opsi → Backup Chat untuk mencadangkan percakapan.",
      category: "Backup",
    ),
    FAQItem(
      question: "Bagaimana cara restore chat?",
      answer:
          "Buka Chat → Opsi → Restore Chat dan pilih file backup.",
      category: "Backup",
    ),
    FAQItem(
      question: "Mengapa verifikasi dua faktor tidak berfungsi?",
      answer:
          "Periksa apakah nomor telepon terdaftar dan jaringan stabil.",
      category: "Akun",
    ),
  ];

  // State untuk daftar FAQ yang sudah difilter (awal = semua FAQ).
  List<FAQItem> _filteredFAQs = [];

  // Daftar kategori yang ditampilkan di dropdown.
  final List<String> categories = ['Semua', 'Akun', 'Teknis', 'Umum', 'Backup'];

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
