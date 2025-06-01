// File: lib/features/settings/presentation/ui/screens/hubungi_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/settings/logic/hubungi_viewmodel.dart';

class HubungiScreen extends StatelessWidget {
  const HubungiScreen({super.key});

  Future<void> _launchUrl(BuildContext context, Uri uri) async {
    if (!await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuka: ${uri.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

@override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HubungiViewModel(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 4,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'Hubungi',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              labelColor: const Color.fromARGB(255, 255, 255, 255),
              unselectedLabelColor: const Color.fromARGB(255, 255, 255, 255),
              tabs: const [
                Tab(
                  icon: Icon(Icons.send_outlined, color: Color.fromARGB(255, 255, 255, 255)),
                  text: 'Kirim Pesan',
                ),
                Tab(
                  icon: Icon(Icons.info_outline, color: Color.fromARGB(255, 255, 255, 255)),
                  text: 'Info Kontak',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              _KirimPesanTab(),
              _InfoKontakTab(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tab 1: Halaman “Kirim Pesan” (form keluhan tanpa indikator loading terpisah)
class _KirimPesanTab extends StatelessWidget {
  const _KirimPesanTab({super.key});

  @override
  Widget build(BuildContext context) {
    // kita hanya mengandalkan loading di tombol, jadi hapus indikator di sini
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HEADER UTAMA
            Column(
              children: const [
                Icon(
                  Icons.support_agent_outlined,
                  size: 72,
                  color: AppColors.primary,
                ),
                SizedBox(height: 8),
                Text(
                  'Hubungi Kami',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Kami siap membantu Anda',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // FORM INPUT (keluhan)
            const _ContactForm(),
          ],
        ),
      ),
    );
  }
}

/// Tab 2: Halaman “Informasi Kontak” (tidak berubah, hanya memanggil _launchUrl)
class _InfoKontakTab extends StatelessWidget {
  const _InfoKontakTab({super.key});

  Future<void> _launchUrl(BuildContext context, Uri uri) async {
    if (!await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuka: ${uri.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: const [
                Icon(
                  Icons.contact_phone_outlined,
                  size: 72,
                  color: AppColors.primary,
                ),
                SizedBox(height: 8),
                Text(
                  'Info Kontak',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Informasi lengkap untuk menghubungi kami',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.grey.shade50,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Telepon
                    ListTile(
                      leading: const Icon(
                        Icons.phone,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      title: const Text(
                        'Telepon',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.text,
                        ),
                      ),
                      subtitle: const Text(
                        '+62 812 3456 7890',
                        style: TextStyle(fontSize: 14),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () async {
                        final Uri phoneUri = Uri(scheme: 'tel', path: '+6281234567890');
                        await _launchUrl(context, phoneUri);
                      },
                    ),
                    const Divider(height: 1, color: Colors.grey),

                    // Email
                    ListTile(
                      leading: const Icon(
                        Icons.email,
                        color: Colors.redAccent,
                        size: 28,
                      ),
                      title: const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.text,
                        ),
                      ),
                      subtitle: const Text(
                        'persmaexplant@gmail.com',
                        style: TextStyle(fontSize: 14),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () async {
                        final Uri emailUri = Uri(
                          scheme: 'mailto',
                          path: 'persmaexplant@gmail.com',
                          queryParameters: {'subject': 'Hubungi Kami'},
                        );
                        await _launchUrl(context, emailUri);
                      },
                    ),
                    const Divider(height: 1, color: Colors.grey),

                    // Alamat
                    ListTile(
                      leading: const Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 28,
                      ),
                      title: const Text(
                        'Alamat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.text,
                        ),
                      ),
                      subtitle: const Text(
                        'Student Activity Center Polije, Jember',
                        style: TextStyle(fontSize: 14),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () async {
                        const String mapsUrl = 'https://maps.app.goo.gl/axfMA8MdvTCC6cNj7';
                        final Uri mapsUri = Uri.parse(mapsUrl);
                        await _launchUrl(context, mapsUri);
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Jam Operasional',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Senin–Jumat, 08:00–17:00 WIB',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Form “Kirim Pesan” (Pelaporan Keluhan) dengan satu loading di button, 
/// menampilkan Snackbar setelah terkirim, dan membersihkan teks deskripsi keluhan.
class _ContactForm extends StatefulWidget {
  const _ContactForm();

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _keluhanController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _keluhanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HubungiViewModel>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Field: Nama Lengkap
            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                labelStyle: const TextStyle(color: AppColors.primary),
                prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Field: Email
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: AppColors.primary),
                prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Field: Deskripsi Keluhan (multi-line)
            TextFormField(
              controller: _keluhanController,
              decoration: InputDecoration(
                labelText: 'Deskripsi Keluhan',
                labelStyle: const TextStyle(color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Keluhan tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Tombol Kirim Keluhan: hanya satu loading indicator di sini
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: vm.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          // panggil sendMessage, tunggu hingga selesai
                          await vm.sendMessage(
                            nama: _namaController.text.trim(),
                            email: _emailController.text.trim(),
                            pesan: _keluhanController.text.trim(),
                          );

                          // setelah sukses, tampilkan Snackbar dan clear field deskripsi
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Pesan berhasil dikirim'),
                                backgroundColor: Color.fromARGB(255, 40, 40, 40),
                              ),
                            );
                          }
                          _keluhanController.clear();
                        }
                      },
                child: vm.isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Mengirim...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'Kirim Keluhan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
