import 'package:flutter/material.dart';

class HubungiScreen extends StatelessWidget {
  const HubungiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hubungi Kami'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan ikon dan judul
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.contact_phone,
                    size: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Hubungi Kami',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Deskripsi singkat
            const Text(
              'Kami siap membantu Anda. Jika ada pertanyaan atau membutuhkan bantuan, silakan hubungi kami melalui informasi di bawah ini atau kirim pesan melalui formulir kontak.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Informasi kontak dalam bentuk Card
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.blue),
                title: const Text('Telepon'),
                subtitle: const Text('+62 812 3456 7890'),
              ),
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.red),
                title: const Text('Email'),
                subtitle: const Text('info@aplikasi.com'),
              ),
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.green),
                title: const Text('Alamat'),
                subtitle: const Text('Jl. Contoh No.123, Jakarta, Indonesia'),
              ),
            ),
            const SizedBox(height: 24),
            // Judul untuk formulir pesan
            const Text(
              'Kirim Pesan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Formulir kontak
            const _ContactForm(),
          ],
        ),
      ),
    );
  }
}

class _ContactForm extends StatefulWidget {
  const _ContactForm({super.key});

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _pesanController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      // Simulasikan pengiriman pesan atau panggil API sesuai kebutuhan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesan telah terkirim!')),
      );
      // Kosongkan field setelah pesan terkirim
      _namaController.clear();
      _emailController.clear();
      _pesanController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Input Nama
          TextFormField(
            controller: _namaController,
            decoration: const InputDecoration(
              labelText: 'Nama',
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Mohon masukkan nama Anda';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Input Email
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Mohon masukkan email Anda';
              }
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return 'Email tidak valid';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Input Pesan
          TextFormField(
            controller: _pesanController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Pesan',
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Mohon masukkan pesan Anda';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          // Tombol Kirim Pesan
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _sendMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Kirim Pesan',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
