import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Widget utama aplikasi dengan konfigurasi tema dan routing.
/// Skema warna indigo memberikan tampilan yang elegan dan profesional.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pusat Bantuan - Help Center',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Gunakan textTheme yang bersih dan modern.
        textTheme: const TextTheme(
          bodySmall: TextStyle(fontSize: 16),
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
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Hubungi Tim Dukungan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                  backgroundColor: Colors.indigo,
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
      answer: 'Untuk mendaftar akun, klik tombol "Daftar" di halaman login dan isi formulir pendaftaran dengan data yang valid.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara mereset password?',
      answer: 'Jika Anda lupa password, klik "Lupa Password?" di halaman login dan ikuti instruksi untuk mereset password melalui email.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara mengubah profil saya?',
      answer: 'Anda dapat mengubah informasi profil melalui menu "Profil" di dalam aplikasi, lalu pilih "Edit Profil" untuk menyimpan perubahan.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Apa yang harus dilakukan jika aplikasi error?',
      answer: 'Cobalah untuk merestart aplikasi. Jika error masih terjadi, hubungi tim dukungan melalui halaman "Hubungi Kami".',
      category: 'Teknis',
    ),
    FAQItem(
      question: 'Bagaimana cara menghubungi tim support?',
      answer: 'Anda dapat menghubungi tim support melalui halaman "Hubungi Kami" atau mengirim email ke support@aplikasi.com.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara mengupdate aplikasi?',
      answer: 'Pastikan aplikasi Anda selalu terupdate dengan mengunjungi Play Store atau App Store dan mengunduh versi terbaru.',
      category: 'Teknis',
    ),
    FAQItem(
      question: 'Apakah data saya aman?',
      answer: 'Kami menerapkan protokol keamanan yang ketat untuk melindungi data pengguna. Informasi lebih lanjut dapat dilihat di Kebijakan Privasi kami.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara menggunakan fitur terbaru?',
      answer: 'Fitur terbaru biasanya disertai panduan penggunaan di dalam aplikasi. Silakan cek bagian Pengumuman atau Blog kami.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara melakukan backup data?',
      answer: 'Untuk melakukan backup data, buka menu "Pengaturan", pilih "Backup & Restore", dan ikuti instruksi untuk mencadangkan data Anda.',
      category: 'Backup',
    ),
    FAQItem(
      question: 'Bagaimana cara mengembalikan data dari backup?',
      answer: 'Untuk mengembalikan data dari backup, pastikan Anda telah melakukan backup sebelumnya, lalu pilih opsi "Restore Data" di menu "Backup & Restore".',
      category: 'Backup',
    ),
    FAQItem(
      question: 'Bagaimana cara menghapus akun?',
      answer: 'Untuk menghapus akun, buka menu "Pengaturan" dan pilih opsi "Hapus Akun". Pastikan Anda membaca konsekuensinya sebelum melanjutkan.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara mengganti email akun?',
      answer: 'Buka profil Anda, pilih "Edit Email" dan ikuti proses verifikasi untuk mengonfirmasi email baru.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara mengganti nomor telepon?',
      answer: 'Pergi ke menu pengaturan akun, pilih "Edit Nomor Telepon", masukkan nomor baru dan verifikasi melalui OTP.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Mengapa saya tidak menerima email verifikasi?',
      answer: 'Pastikan email yang Anda masukkan benar dan periksa folder spam. Jika masih bermasalah, hubungi dukungan kami.',
      category: 'Teknis',
    ),
    FAQItem(
      question: 'Apa itu verifikasi dua langkah?',
      answer: 'Verifikasi dua langkah adalah lapisan tambahan keamanan yang meminta kode khusus saat login.',
      category: 'Keamanan',
    ),
    FAQItem(
      question: 'Bagaimana cara mengaktifkan verifikasi dua langkah?',
      answer: 'Aktifkan fitur verifikasi dua langkah melalui pengaturan keamanan pada profil Anda.',
      category: 'Keamanan',
    ),
    FAQItem(
      question: 'Bagaimana cara melaporkan bug?',
      answer: 'Anda dapat melaporkan bug melalui menu "Bantuan" di aplikasi atau dengan mengirim email ke support@aplikasi.com.',
      category: 'Teknis',
    ),
    FAQItem(
      question: 'Bagaimana cara mengembalikan versi sebelumnya?',
      answer: 'Beberapa aplikasi menyediakan opsi rollback di pengaturan, namun disarankan menggunakan versi terbaru untuk keamanan dan performa terbaik.',
      category: 'Teknis',
    ),
    FAQItem(
      question: 'Apa yang dimaksud dengan mode offline?',
      answer: 'Mode offline memungkinkan Anda menggunakan aplikasi tanpa koneksi internet, meskipun beberapa fitur mungkin terbatas.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara menyimpan artikel untuk dibaca offline?',
      answer: 'Tekan tombol "Simpan" di bawah artikel untuk menyimpannya dan membacanya tanpa koneksi internet.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Apakah aplikasi mendukung multi bahasa?',
      answer: 'Ya, Anda dapat mengubah bahasa aplikasi melalui menu "Pengaturan" sesuai dengan preferensi Anda.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara menonaktifkan notifikasi?',
      answer: 'Masuk ke menu "Pengaturan", pilih "Notifikasi" dan nonaktifkan notifikasi sesuai keinginan Anda.',
      category: 'Pengaturan',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur preferensi notifikasi?',
      answer: 'Anda dapat memilih jenis notifikasi yang ingin diterima melalui menu "Pengaturan" di aplikasi.',
      category: 'Pengaturan',
    ),
    FAQItem(
      question: 'Bagaimana cara mengubah tema aplikasi?',
      answer: 'Pilih opsi "Tema" di menu pengaturan dan pilih mode terang atau gelap sesuai selera Anda.',
      category: 'Pengaturan',
    ),
    FAQItem(
      question: 'Apakah ada fitur penyimpanan awan?',
      answer: 'Ya, aplikasi ini mendukung penyimpanan awan untuk menyinkronkan data di berbagai perangkat.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara mengintegrasikan aplikasi dengan kalender?',
      answer: 'Buka menu integrasi dan pilih opsi "Sinkronisasi Kalender" untuk menghubungkan acara Anda dengan kalender.',
      category: 'Integrasi',
    ),
    FAQItem(
      question: 'Apa keuntungan menggunakan sinkronisasi otomatis?',
      answer: 'Sinkronisasi otomatis memastikan data Anda selalu terupdate di semua perangkat tanpa harus melakukannya secara manual.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara menambahkan akun media sosial?',
      answer: 'Masuk ke profil, pilih "Tambahkan Media Sosial" dan ikuti instruksi untuk menghubungkan akun media sosial Anda.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara mengubah password melalui aplikasi?',
      answer: 'Buka menu "Keamanan" di pengaturan akun dan pilih opsi "Ganti Password" untuk memperbarui kata sandi.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Apa yang harus dilakukan jika terjadi kesalahan pembayaran?',
      answer: 'Segera hubungi tim dukungan dengan menyertakan bukti transaksi untuk menyelesaikan permasalahan pembayaran.',
      category: 'Pembayaran',
    ),
    FAQItem(
      question: 'Bagaimana cara melihat riwayat transaksi?',
      answer: 'Riwayat transaksi dapat diakses melalui menu "Transaksi" pada akun Anda.',
      category: 'Transaksi',
    ),
    FAQItem(
      question: 'Bagaimana cara mengunduh laporan transaksi?',
      answer: 'Gunakan tombol "Unduh Laporan" di menu transaksi untuk mendapatkan laporan dalam format PDF.',
      category: 'Transaksi',
    ),
    FAQItem(
      question: 'Apakah saya bisa mencetak laporan transaksi?',
      answer: 'Setelah mengunduh laporan, Anda dapat mencetaknya menggunakan printer yang terhubung dengan perangkat Anda.',
      category: 'Transaksi',
    ),
    FAQItem(
      question: 'Bagaimana cara menambahkan metode pembayaran?',
      answer: 'Masuk ke menu "Pembayaran", pilih "Tambah Metode", dan masukkan detail kartu kredit atau debit Anda.',
      category: 'Pembayaran',
    ),
    FAQItem(
      question: 'Bagaimana cara menghapus metode pembayaran?',
      answer: 'Di menu "Pembayaran", pilih metode yang ingin dihapus dan konfirmasi penghapusan.',
      category: 'Pembayaran',
    ),
    FAQItem(
      question: 'Apakah aplikasi menyediakan diskon khusus?',
      answer: 'Kami sering menawarkan diskon dan promo khusus. Silakan cek bagian "Promo" untuk informasi terbaru.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara memanfaatkan voucher diskon?',
      answer: 'Masukkan kode voucher saat checkout untuk mendapatkan potongan harga sesuai ketentuan yang berlaku.',
      category: 'Pembayaran',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur jadwal backup otomatis?',
      answer: 'Di menu "Backup & Restore", aktifkan opsi "Backup Otomatis" dan atur jadwal backup sesuai preferensi Anda.',
      category: 'Backup',
    ),
    FAQItem(
      question: 'Apa yang harus dilakukan jika backup gagal?',
      answer: 'Pastikan koneksi internet stabil dan ruang penyimpanan mencukupi. Jika masalah berlanjut, hubungi dukungan kami.',
      category: 'Backup',
    ),
    FAQItem(
      question: 'Bagaimana cara menghapus cache aplikasi?',
      answer: 'Buka pengaturan aplikasi di perangkat Anda dan pilih opsi "Hapus Cache" untuk membersihkan data sementara.',
      category: 'Teknis',
    ),
    FAQItem(
      question: 'Bagaimana cara meningkatkan kinerja aplikasi?',
      answer: 'Pastikan aplikasi selalu diperbarui dan tutup aplikasi lain yang berjalan di latar belakang untuk mengoptimalkan kinerja.',
      category: 'Teknis',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur notifikasi untuk pesan masuk?',
      answer: 'Masuk ke menu "Notifikasi" dan sesuaikan preferensi notifikasi pesan masuk sesuai keinginan Anda.',
      category: 'Pengaturan',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur privasi akun?',
      answer: 'Masuk ke pengaturan akun dan pilih opsi "Privasi" untuk mengatur siapa saja yang dapat melihat informasi pribadi Anda.',
      category: 'Keamanan',
    ),
    FAQItem(
      question: 'Apa yang dimaksud dengan data terenkripsi?',
      answer: 'Data terenkripsi berarti data Anda diubah menjadi format yang tidak dapat dibaca tanpa kunci enkripsi khusus.',
      category: 'Keamanan',
    ),
    FAQItem(
      question: 'Bagaimana cara mengaktifkan mode gelap?',
      answer: 'Masuk ke pengaturan tampilan dan pilih opsi "Mode Gelap" untuk mengubah tampilan aplikasi menjadi gelap.',
      category: 'Pengaturan',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur bahasa dalam aplikasi?',
      answer: 'Buka menu "Pengaturan", pilih "Bahasa", dan tentukan bahasa yang ingin Anda gunakan dalam aplikasi.',
      category: 'Pengaturan',
    ),
    FAQItem(
      question: 'Bagaimana cara mengembalikan pengaturan default?',
      answer: 'Di menu "Pengaturan", pilih opsi "Reset ke Default" untuk mengembalikan semua pengaturan ke kondisi awal.',
      category: 'Pengaturan',
    ),
    FAQItem(
      question: 'Bagaimana cara memulihkan data yang terhapus?',
      answer: 'Periksa backup terbaru Anda dan gunakan opsi "Restore Data" di menu "Backup & Restore" untuk memulihkan data yang hilang.',
      category: 'Backup',
    ),
    FAQItem(
      question: 'Bagaimana cara mengubah format tanggal?',
      answer: 'Masuk ke menu "Pengaturan", pilih "Format Tanggal", dan pilih format tanggal yang sesuai dengan preferensi Anda.',
      category: 'Pengaturan',
    ),
    FAQItem(
      question: 'Bagaimana cara menggunakan fitur pencarian?',
      answer: 'Gunakan ikon pencarian di bagian atas layar untuk mencari konten atau informasi yang Anda butuhkan dalam aplikasi.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara memfilter konten berdasarkan kategori?',
      answer: 'Di halaman FAQ, gunakan filter kategori untuk menampilkan pertanyaan yang relevan dengan topik tertentu.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara menghubungkan aplikasi dengan layanan pihak ketiga?',
      answer: 'Buka menu "Integrasi" dan pilih layanan pihak ketiga yang ingin dihubungkan, kemudian ikuti instruksi yang ditampilkan.',
      category: 'Integrasi',
    ),
    FAQItem(
      question: 'Apakah aplikasi mendukung penggunaan offline mode?',
      answer: 'Ya, aplikasi menyediakan mode offline untuk beberapa fitur, meskipun akses penuh membutuhkan koneksi internet.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara mengaktifkan sinkronisasi otomatis?',
      answer: 'Aktifkan opsi sinkronisasi di menu "Pengaturan" agar data Anda selalu terupdate di semua perangkat.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara mengubah layout tampilan aplikasi?',
      answer: 'Di menu "Pengaturan", pilih opsi "Tampilan" dan pilih layout yang paling sesuai dengan preferensi Anda.',
      category: 'Pengaturan',
    ),
    FAQItem(
      question: 'Bagaimana cara melihat notifikasi terbaru?',
      answer: 'Klik ikon lonceng di pojok atas layar untuk melihat semua notifikasi terbaru yang masuk.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara mengarsipkan chat?',
      answer: 'Geser chat ke kiri dan pilih opsi "Arsipkan" untuk menyimpan percakapan tanpa menghapusnya secara permanen.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara mengembalikan chat yang diarsipkan?',
      answer: 'Buka folder arsip dan pilih chat yang ingin dipulihkan ke daftar percakapan utama.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur status online?',
      answer: 'Masuk ke pengaturan akun dan pilih opsi "Status Online" untuk mengatur ketersediaan Anda secara real-time.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara mengubah foto profil?',
      answer: 'Di menu "Profil", klik foto profil Anda dan pilih "Ganti Foto" untuk mengunggah gambar baru.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara menambahkan deskripsi di profil?',
      answer: 'Masuk ke profil Anda dan pilih opsi "Edit Deskripsi" untuk menambahkan informasi tentang diri Anda.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara menambahkan alamat pada akun?',
      answer: 'Buka menu "Akun" dan pilih opsi "Tambah Alamat" untuk memasukkan alamat lengkap Anda.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara menghapus alamat yang tersimpan?',
      answer: 'Di menu "Akun", pilih alamat yang ingin dihapus dan konfirmasi pilihan Anda.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara memverifikasi akun melalui SMS?',
      answer: 'Masukkan nomor telepon Anda dan tunggu SMS verifikasi yang dikirim untuk mengonfirmasi akun Anda.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara mengaktifkan mode privasi?',
      answer: 'Aktifkan mode privasi di menu pengaturan akun untuk membatasi akses ke informasi pribadi Anda.',
      category: 'Keamanan',
    ),
    FAQItem(
      question: 'Bagaimana cara melaporkan konten yang tidak pantas?',
      answer: 'Gunakan fitur "Laporkan" yang tersedia pada setiap konten untuk memberitahukan pelanggaran.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara memblokir pengguna?',
      answer: 'Di profil pengguna, pilih opsi "Blokir" untuk menghentikan interaksi dengan pengguna tersebut.',
      category: 'Keamanan',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur filter konten?',
      answer: 'Masuk ke menu "Pengaturan" dan pilih opsi "Filter Konten" untuk menyesuaikan jenis konten yang ingin Anda lihat.',
      category: 'Pengaturan',
    ),
    FAQItem(
      question: 'Bagaimana cara melakukan pencadangan data secara manual?',
      answer: 'Pilih opsi "Backup Sekarang" di menu "Backup & Restore" untuk memulai pencadangan manual data Anda.',
      category: 'Backup',
    ),
    FAQItem(
      question: 'Bagaimana cara mengetahui versi aplikasi yang saya gunakan?',
      answer: 'Buka menu "Tentang Aplikasi" untuk melihat informasi versi dan detail lainnya mengenai aplikasi.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara menghubungkan akun dengan Google?',
      answer: 'Masuk ke profil dan pilih opsi "Hubungkan dengan Google" untuk menyinkronkan akun Anda.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara menghubungkan akun dengan Facebook?',
      answer: 'Masuk ke profil dan pilih opsi "Hubungkan dengan Facebook" untuk mengintegrasikan akun media sosial Anda.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara mengubah setelan privasi untuk postingan?',
      answer: 'Di menu "Pengaturan", pilih "Privasi Postingan" dan atur siapa saja yang dapat melihat postingan Anda.',
      category: 'Keamanan',
    ),
    FAQItem(
      question: 'Bagaimana cara melaporkan aktivitas mencurigakan?',
      answer: 'Jika Anda menemukan aktivitas yang mencurigakan, segera laporkan melalui fitur "Laporkan" di aplikasi.',
      category: 'Keamanan',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur preferensi tampilan?',
      answer: 'Masuk ke menu "Pengaturan" dan pilih opsi "Preferensi Tampilan" untuk menyesuaikan antarmuka aplikasi.',
      category: 'Pengaturan',
    ),
    FAQItem(
      question: 'Bagaimana cara mengelola notifikasi email?',
      answer: 'Buka menu "Pengaturan" dan pilih "Notifikasi Email" untuk mengatur email yang dikirim oleh aplikasi.',
      category: 'Pengaturan',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur backup data ke cloud?',
      answer: 'Masuk ke menu "Backup & Restore", pilih opsi "Backup ke Cloud", dan ikuti instruksi untuk mencadangkan data secara online.',
      category: 'Backup',
    ),
    FAQItem(
      question: 'Bagaimana cara memulihkan data dari cloud?',
      answer: 'Di menu "Backup & Restore", pilih opsi "Restore dari Cloud" untuk memulihkan data yang telah dicadangkan secara online.',
      category: 'Backup',
    ),
    FAQItem(
      question: 'Bagaimana cara menambah kontak darurat?',
      answer: 'Buka menu "Kontak Darurat" dan pilih "Tambah Kontak" untuk memasukkan nomor penting yang dapat dihubungi.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara menghapus kontak darurat?',
      answer: 'Masuk ke menu "Kontak Darurat", pilih kontak yang ingin dihapus, dan konfirmasi penghapusan.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara mendapatkan update informasi terkini?',
      answer: 'Aktifkan notifikasi di menu "Pengaturan" atau kunjungi halaman "Berita" untuk mendapatkan update terbaru.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara mengunduh aplikasi versi beta?',
      answer: 'Daftarkan diri Anda ke program beta melalui situs resmi kami dan ikuti petunjuk pengunduhan versi beta aplikasi.',
      category: 'Teknis',
    ),
    FAQItem(
      question: 'Bagaimana cara mendapatkan bantuan teknis secara langsung?',
      answer: 'Hubungi tim teknis melalui fitur "Live Chat" atau kirim email ke support@aplikasi.com untuk bantuan langsung.',
      category: 'Teknis',
    ),
    FAQItem(
      question: 'Bagaimana cara mengintegrasikan aplikasi dengan perangkat wearable?',
      answer: 'Buka menu "Integrasi" dan pilih perangkat wearable yang didukung untuk menghubungkannya dengan aplikasi.',
      category: 'Integrasi',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur sinkronisasi data secara manual?',
      answer: 'Di menu "Pengaturan", pilih opsi "Sinkronisasi Manual" untuk memperbarui data secara real-time.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara mengecek status server aplikasi?',
      answer: 'Kunjungi halaman status server atau hubungi dukungan untuk mendapatkan informasi terkini mengenai performa server.',
      category: 'Teknis',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur notifikasi push?',
      answer: 'Masuk ke menu "Pengaturan" dan pilih opsi "Notifikasi Push" untuk mengaktifkan atau menonaktifkan push notification.',
      category: 'Pengaturan',
    ),
    FAQItem(
      question: 'Bagaimana cara mengubah pengaturan akun secara keseluruhan?',
      answer: 'Masuk ke menu "Pengaturan Akun" dan sesuaikan preferensi akun Anda sesuai kebutuhan.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara menghapus riwayat pencarian?',
      answer: 'Buka menu "Riwayat Pencarian" dan pilih opsi "Hapus Riwayat" untuk membersihkan data pencarian Anda.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara mengunduh data pribadi saya?',
      answer: 'Di menu "Pengaturan", pilih opsi "Unduh Data" untuk mendapatkan salinan data pribadi Anda.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara mengganti kata sandi untuk email?',
      answer: 'Masuk ke pengaturan akun dan pilih opsi "Ganti Kata Sandi Email" untuk memperbarui password email Anda.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara menyinkronkan data antar perangkat?',
      answer: 'Aktifkan opsi sinkronisasi di menu "Pengaturan" untuk memastikan data Anda selalu terupdate di semua perangkat.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara memverifikasi transaksi pembayaran?',
      answer: 'Transaksi pembayaran biasanya memerlukan verifikasi melalui OTP atau email untuk memastikan keamanan.',
      category: 'Pembayaran',
    ),
    FAQItem(
      question: 'Bagaimana cara melacak pengiriman barang?',
      answer: 'Gunakan fitur pelacakan di menu "Transaksi" dan masukkan nomor resi untuk mengetahui status pengiriman.',
      category: 'Transaksi',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur notifikasi pembaruan promo?',
      answer: 'Di menu "Promo", aktifkan notifikasi untuk mendapatkan informasi diskon dan promo terbaru.',
      category: 'Pembayaran',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur preferensi bahasa untuk konten?',
      answer: 'Masuk ke menu "Pengaturan", pilih opsi "Bahasa Konten", dan tentukan bahasa yang ingin ditampilkan.',
      category: 'Pengaturan',
    ),
    FAQItem(
      question: 'Bagaimana cara mengubah lokasi penyimpanan data?',
      answer: 'Buka menu "Pengaturan", pilih opsi "Lokasi Penyimpanan" dan atur lokasi penyimpanan sesuai kebutuhan Anda.',
      category: 'Pengaturan',
    ),
    FAQItem(
      question: 'Bagaimana cara menghubungkan aplikasi dengan layanan kesehatan?',
      answer: 'Di menu "Integrasi", pilih layanan kesehatan yang tersedia untuk menghubungkan data kesehatan Anda.',
      category: 'Integrasi',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur privasi dalam fitur streaming?',
      answer: 'Masuk ke menu "Pengaturan", pilih opsi "Privasi Streaming" untuk mengatur siapa saja yang dapat mengakses fitur streaming Anda.',
      category: 'Keamanan',
    ),
    FAQItem(
      question: 'Bagaimana cara mengunduh panduan pengguna?',
      answer: 'Kunjungi halaman "Bantuan" atau unduh panduan pengguna dari situs resmi aplikasi kami.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara mengakses mode demo?',
      answer: 'Pilih opsi "Mode Demo" di halaman utama untuk mencoba fitur aplikasi tanpa mendaftar akun.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur filter pencarian?',
      answer: 'Masuk ke menu "Pengaturan" dan pilih "Filter Pencarian" untuk menyesuaikan hasil pencarian sesuai keinginan Anda.',
      category: 'Pengaturan',
    ),
    FAQItem(
      question: 'Bagaimana cara melihat riwayat aktivitas?',
      answer: 'Riwayat aktivitas Anda dapat dilihat di menu "Aktivitas" yang mencatat semua tindakan di dalam aplikasi.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur jadwal pertemuan?',
      answer: 'Gunakan fitur "Jadwal Pertemuan" untuk mengatur waktu dan tanggal pertemuan langsung melalui aplikasi.',
      category: 'Umum',
    ),
    FAQItem(
      question: 'Bagaimana cara mengatur notifikasi untuk event khusus?',
      answer: 'Masuk ke menu "Pengaturan", pilih "Notifikasi Event", dan aktifkan notifikasi untuk mendapatkan update tentang event khusus.',
      category: 'Pengaturan',
    ),
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
        final matchesCategory = _selectedCategory == 'Semua' ? true : faq.category == _selectedCategory;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Butuh Bantuan?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Cari jawaban dari pertanyaan yang sering diajukan atau hubungi tim dukungan kami.',
          style: TextStyle(fontSize: 16, color: Colors.black87),
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

  /// Dropdown filter kategori.
  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
        backgroundColor: Colors.indigo,
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
                    backgroundColor: Colors.indigo,
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
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
