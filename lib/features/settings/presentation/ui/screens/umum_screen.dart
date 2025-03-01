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
      title: 'Edit Profil Modern',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        // Gantikan accentColor dengan properti colorScheme.secondary
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
            .copyWith(secondary: Colors.amber),
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          elevation: 4,
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        // Update properti TextTheme sesuai Material 3
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
      home: const UmumScreen(),
    );
  }
}

/// Halaman utama Edit Profil (UmumScreen)
class UmumScreen extends StatefulWidget {
  const UmumScreen({super.key});

  @override
  State<UmumScreen> createState() => _UmumScreenState();
}

class _UmumScreenState extends State<UmumScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _namaLengkapController;
  final String _role = "Pembaca";
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: "username_default");
    _namaLengkapController =
        TextEditingController(text: "Nama Lengkap Default");
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _namaLengkapController.dispose();
    super.dispose();
  }

  void _pickImage() {
    setState(() {
      _profileImagePath = 'assets/profile_sample.png';
    });
  }

  Future<void> _editUsername() async {
    final String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFieldScreen(
          title: "Ubah Username",
          initialValue: _usernameController.text,
          description:
              "Username hanya boleh mengandung huruf, angka, dan underscore.",
          fieldLabel: "Username",
          validator: (value) {
            final regex = RegExp(r'^[a-zA-Z0-9_]+$');
            if (!regex.hasMatch(value)) {
              return 'Username tidak valid! (hanya huruf, angka, dan underscore)';
            }
            return null;
          },
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _usernameController.text = result;
      });
    }
  }

  Future<void> _editNamaLengkap() async {
    final String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFieldScreen(
          title: "Ubah Nama Lengkap",
          initialValue: _namaLengkapController.text,
          description: "Nama lengkap akan ditampilkan di profil Anda.",
          fieldLabel: "Nama Lengkap",
          validator: (value) {
            if (value.trim().isEmpty) {
              return 'Nama Lengkap tidak boleh kosong!';
            }
            return null;
          },
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _namaLengkapController.text = result;
      });
    }
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Hero(
              tag: 'profile-image',
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _profileImagePath != null
                    ? AssetImage(_profileImagePath!)
                    : const AssetImage('assets/default_profile.png'),
              ),
            ),
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
      ],
    );
  }

  Widget _buildEditableFieldCard({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildNonEditableFieldCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Role tidak bisa diubah"),
              duration: Duration(seconds: 2),
            ),
          );
        },
        leading: Icon(icon, color: Colors.grey),
        title: Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil Umum"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildEditableFieldCard(
              label: "Nama Lengkap",
              value: _namaLengkapController.text,
              icon: Icons.account_circle,
              onTap: _editNamaLengkap,
            ),
            _buildEditableFieldCard(
              label: "Username",
              value: _usernameController.text,
              icon: Icons.person,
              onTap: _editUsername,
            ),
            _buildNonEditableFieldCard(
              label: "Role",
              value: _role,
              icon: Icons.verified_user_outlined,
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

typedef FieldValidator = String? Function(String value);

/// Widget generik untuk halaman edit field.
class EditFieldScreen extends StatefulWidget {
  final String title;
  final String initialValue;
  final String
      description; // Contoh: "Nama lengkap akan ditampilkan di profil. Hanya boleh berisi huruf dan spasi, minimal 3 karakter."
  final String fieldLabel;
  final FieldValidator? validator;

  const EditFieldScreen({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.description,
    required this.fieldLabel,
    this.validator,
  }) : super(key: key);

  @override
  State<EditFieldScreen> createState() => _EditFieldScreenState();
}

class _EditFieldScreenState extends State<EditFieldScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(() {
      setState(() {}); // Untuk mengupdate tampilan ikon clear
    });
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Fungsi untuk menyimpan nilai dengan validasi dan animasi fade out sebelum kembali.
  void _save() {
    if (_formKey.currentState!.validate()) {
      _animationController.reverse().then((value) {
        Navigator.pop(context, _controller.text);
      });
    }
  }

  // Fungsi untuk membatalkan edit dan kembali ke halaman sebelumnya.
  void _cancel() {
    Navigator.pop(context, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar dengan tampilan minimalis dan ukuran tulisan yang pas.
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: TextButton(
          onPressed: _cancel,
          child: const Text(
            "Batal",
            style: TextStyle(color: Colors.black, fontSize: 13),
          ),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              "Simpan",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      // Menggunakan FadeTransition untuk animasi halaman.
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // TextFormField dengan styling modern dan clear icon
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _controller,
                    autofocus: true,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: widget.fieldLabel,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      // Clear icon yang muncul saat ada teks
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _controller.clear();
                              },
                            )
                          : null,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Tidak boleh kosong";
                      }
                      if (widget.validator != null) {
                        return widget.validator!(value);
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // Deskripsi field (contoh untuk Nama Lengkap)
                Text(
                  widget.description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
