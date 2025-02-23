import 'package:flutter/material.dart';

class PusatBantuanScreen extends StatelessWidget {
  const PusatBantuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Bantuan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dan deskripsi singkat
            const Text(
              'Butuh Bantuan?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cari jawaban dari pertanyaan yang sering diajukan atau hubungi tim dukungan kami.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Kolom pencarian
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari bantuan...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Judul FAQ
            const Text(
              'Pertanyaan yang Sering Diajukan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Daftar FAQ menggunakan ExpansionTile
            _buildFAQItem(
              question: 'Bagaimana cara mendaftar akun?',
              answer:
                  'Untuk mendaftar akun, Anda dapat mengklik tombol "Daftar" di halaman login dan mengisi formulir pendaftaran dengan data yang valid.',
            ),
            _buildFAQItem(
              question: 'Bagaimana cara mereset password?',
              answer:
                  'Jika Anda lupa password, klik "Lupa Password?" di halaman login, lalu ikuti petunjuk untuk reset password melalui email Anda.',
            ),
            _buildFAQItem(
              question: 'Bagaimana cara mengubah profil saya?',
              answer:
                  'Anda dapat mengubah informasi profil melalui menu "Profil" di dalam aplikasi, lalu pilih "Edit Profil" dan simpan perubahan Anda.',
            ),
            _buildFAQItem(
              question: 'Apa yang harus dilakukan jika aplikasi mengalami error?',
              answer:
                  'Jika aplikasi mengalami error, coba restart aplikasi terlebih dahulu. Jika masih berlanjut, hubungi tim dukungan kami melalui halaman "Hubungi Kami".',
            ),
            _buildFAQItem(
              question: 'Bagaimana cara menghubungi tim support?',
              answer:
                  'Anda dapat menghubungi tim support melalui halaman "Hubungi Kami" atau mengirim email ke support@aplikasi.com.',
            ),
            const SizedBox(height: 24),
            // Tombol untuk menghubungi tim dukungan
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/hubungi'); // pastikan route sudah tersedia
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
          ],
        ),
      ),
    );
  }

  // Widget helper untuk membuat item FAQ
  Widget _buildFAQItem({required String question, required String answer}) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            answer,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}