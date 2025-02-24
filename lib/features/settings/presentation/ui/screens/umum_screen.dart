import 'package:flutter/material.dart';

/// Halaman Umum (Edit Profil)
/// Halaman ini memungkinkan pengguna untuk mengubah foto profil, mengedit
/// username dan nama lengkap secara inline (tanpa pop-up) dengan cara mengetuk ikon
/// pensil yang akan mengubah tampilan field menjadi TextField. Data role ditampilkan
/// sebagai informasi read-only.
class UmumScreen extends StatefulWidget {
  const UmumScreen({super.key});

  @override
  State<UmumScreen> createState() => _UmumScreenState();
}

class _UmumScreenState extends State<UmumScreen> {
  // Controller untuk mengelola input teks pada field username dan nama lengkap.
  late TextEditingController _usernameController;
  late TextEditingController _namaLengkapController;

  // Variabel untuk menentukan apakah field sedang dalam mode editing.
  bool _isEditingUsername = false;
  bool _isEditingNamaLengkap = false;

  // Role pengguna, bersifat read-only dan tidak dapat diedit.
  final String _role = "Pembaca";

  // Placeholder untuk path foto profil yang dipilih.
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai default.
    _usernameController = TextEditingController(text: "username_default");
    _namaLengkapController =
        TextEditingController(text: "Nama Lengkap Default");
  }

  @override
  void dispose() {
    // Pastikan untuk membuang controller saat widget dihancurkan.
    _usernameController.dispose();
    _namaLengkapController.dispose();
    super.dispose();
  }

  /// Fungsi simulasi untuk memilih foto profil.
  /// Implementasi sebenarnya dapat menggunakan package seperti image_picker.
  void _pickImage() {
    setState(() {
      // Untuk simulasi, kita hanya mengubah path asset.
      _profileImagePath = 'assets/profile_sample.png';
    });
  }

  /// Fungsi untuk menyimpan perubahan profil.
  /// Fungsi ini mematikan mode edit untuk semua field dan menampilkan notifikasi.
  void _saveProfile() {
    setState(() {
      _isEditingUsername = false;
      _isEditingNamaLengkap = false;
    });
    // Simulasi penyimpanan data profil (misal, panggil API)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Perubahan profil berhasil disimpan!")),
    );
  }

  /// Widget untuk menampilkan field yang dapat diedit secara inline.
  /// Saat mode editing aktif, tampilan akan berubah menjadi TextField dengan tombol simpan dan batal.
  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required IconData icon,
    required VoidCallback onEdit,
    required VoidCallback onSave,
    required VoidCallback onCancel,
  }) {
    if (isEditing) {
      // Tampilan saat sedang dalam mode editing: menampilkan TextField beserta tombol simpan dan batal.
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon field
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 12),
            // Expanded TextField agar mengisi ruang yang tersedia.
            Expanded(
              child: TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: label,
                  // Menggunakan OutlineInputBorder dengan sudut membulat.
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Tombol simpan (ikon centang)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: onSave,
            ),
            // Tombol batal (ikon silang)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: onCancel,
            ),
          ],
        ),
      );
    } else {
      // Tampilan saat mode editing tidak aktif: menampilkan nilai sebagai teks dengan ikon edit.
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 12),
            // Informasi field ditampilkan menggunakan Column agar label dan nilai tampil terpisah.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label field
                  Text(
                    label,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  // Nilai field
                  Text(
                    controller.text,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            // Tombol edit (ikon pensil)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
          ],
        ),
      );
    }
  }

  /// Widget untuk menampilkan field read-only.
  /// Field ini tidak memiliki opsi edit.
  Widget _buildNonEditableField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget utama untuk membangun tampilan halaman.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Umum"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Foto Profil dengan tombol untuk mengganti foto
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImagePath != null
                      ? AssetImage(_profileImagePath!) as ImageProvider
                      : const AssetImage('assets/default_profile.png'),
                ),
                // Tombol ganti foto (ikon kamera)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Field Username (editable inline)
            _buildEditableField(
              label: "Username",
              controller: _usernameController,
              isEditing: _isEditingUsername,
              icon: Icons.person,
              onEdit: () {
                setState(() {
                  _isEditingUsername = true;
                });
              },
              onSave: () {
                setState(() {
                  _isEditingUsername = false;
                });
              },
              onCancel: () {
                setState(() {
                  // Reset controller ke nilai default jika dibatalkan
                  _usernameController.text = "username_default";
                  _isEditingUsername = false;
                });
              },
            ),
            const SizedBox(height: 16),
            // Field Nama Lengkap (editable inline)
            _buildEditableField(
              label: "Nama Lengkap",
              controller: _namaLengkapController,
              isEditing: _isEditingNamaLengkap,
              icon: Icons.account_circle,
              onEdit: () {
                setState(() {
                  _isEditingNamaLengkap = true;
                });
              },
              onSave: () {
                setState(() {
                  _isEditingNamaLengkap = false;
                });
              },
              onCancel: () {
                setState(() {
                  // Reset controller ke nilai default jika dibatalkan
                  _namaLengkapController.text = "Nama Lengkap Default";
                  _isEditingNamaLengkap = false;
                });
              },
            ),
            const SizedBox(height: 16),
            // Field Role (read-only)
            _buildNonEditableField(
              label: "Role",
              value: _role,
              icon: Icons.verified_user_outlined,
            ),
          ],
        ),
      ),
    );
  }
}