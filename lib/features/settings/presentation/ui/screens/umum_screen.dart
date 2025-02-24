import 'package:flutter/material.dart';

class UmumScreen extends StatefulWidget {
  const UmumScreen({super.key});

  @override
  State<UmumScreen> createState() => _UmumScreenState();
}

class _UmumScreenState extends State<UmumScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _namaLengkapController;

  // Placeholder untuk foto profil, misalnya asset default
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: "username_default");
    _namaLengkapController = TextEditingController(text: "Nama Lengkap Default");
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _namaLengkapController.dispose();
    super.dispose();
  }

  // Fungsi simulasi untuk memilih foto profil
  void _pickImage() async {
    // Implementasi pemilihan gambar dapat menggunakan package seperti image_picker.
    // Untuk simulasi, kita hanya mengubah path asset.
    setState(() {
      _profileImagePath = 'assets/profile_sample.png';
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Simulasikan penyimpanan data profil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Perubahan profil berhasil disimpan!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Umum"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto Profil dengan tombol ganti foto
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImagePath != null
                        ? AssetImage(_profileImagePath!) as ImageProvider
                        : const AssetImage('assets/default_profile.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Input untuk Username
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Mohon masukkan username";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Input untuk Nama Lengkap
              TextFormField(
                controller: _namaLengkapController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: const Icon(Icons.account_circle),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Mohon masukkan nama lengkap";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Tampilkan Role (Read-only)
              TextFormField(
                initialValue: 'Pembaca',
                decoration: InputDecoration(
                  labelText: 'Role',
                  prefixIcon: const Icon(Icons.verified_user_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 24),
              // Tombol untuk menyimpan perubahan
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Simpan Perubahan",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
