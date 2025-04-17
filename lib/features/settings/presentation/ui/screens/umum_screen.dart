import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mediaexplant/core/network/api_client.dart';
// Import UmumViewModel dari path yang sesuai.
import 'package:mediaexplant/features/settings/logic/umum_viewmodel.dart';

MaterialColor createMaterialColor(Color color) {
  List<double> strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;
  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Profil Modern',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(AppColors.primary),
        ).copyWith(secondary: AppColors.text),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          elevation: 4,
          centerTitle: true,
          backgroundColor: AppColors.primary,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.text),
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.text),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.primary,
          selectionColor: AppColors.primary.withOpacity(0.4),
          selectionHandleColor: AppColors.primary,
        ),
      ),
      home: const UmumScreen(),
    );
  }
}

class UmumScreen extends StatefulWidget {
  const UmumScreen({super.key});
  
  @override
  State<UmumScreen> createState() => _UmumScreenState();
}

class _UmumScreenState extends State<UmumScreen> {
  // Controller untuk field edit; awalnya kosong.
  late TextEditingController _usernameController;
  late TextEditingController _namaLengkapController;

  // Untuk foto profil, jika dipilih secara lokal.
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _namaLengkapController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _namaLengkapController.dispose();
    super.dispose();
  }

  /// Mengembalikan warna latar untuk avatar berdasarkan huruf pertama nama lengkap.
  Color _getAvatarColor() {
    if (_namaLengkapController.text.trim().isEmpty) return Colors.grey;
    int code = _namaLengkapController.text.trim()[0].toUpperCase().codeUnitAt(0);
    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.brown,
      Colors.cyan,
      Colors.amber,
    ];
    int index = (code - 65) % colors.length;
    if (index < 0) index = 0;
    return colors[index];
  }

  /// Meng-crop gambar menggunakan ImageCropper.
  Future<File?> _cropImage(File imageFile) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        compressFormat: ImageCompressFormat.png,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
          ),
        ],
      );
      if (croppedFile == null) return null;
      return File(croppedFile.path);
    } catch (e) {
      debugPrint("Error saat crop image: $e");
      return null;
    }
  }

/// Menampilkan opsi pemilihan gambar (hapus, ambil dari kamera, pilih dari galeri).
Future<void> _showImageOptions() async {
  // simpan context utama agar selalu aktif
  final parentContext = context;
  final scaffoldMessenger = ScaffoldMessenger.of(parentContext);

  showModalBottomSheet(
    context: parentContext,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Pilih Opsi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            
            if (_profileImage != null)
              ListTile(
                leading: const Icon(Icons.delete, color: AppColors.primary),
                title: const Text('Hapus Foto'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  setState(() => _profileImage = null);
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text("Foto profil dihapus"))
                  );
                },
              ),

            // Ambil dari Kamera
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Ambil dari Kamera'),
              onTap: () async {
                Navigator.of(sheetContext).pop();
                try {
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.camera
                  );
                  if (pickedFile == null) return;

                  final File imageFile = File(pickedFile.path);
                  final File? cropped = await _cropImage(imageFile);
                  if (cropped == null) return;

                  setState(() => _profileImage = cropped);

                  // gunakan parentContext untuk update dan SnackBar
                  await Provider.of<UmumViewModel>(
                    parentContext,
                    listen: false,
                  ).updateProfileImage(cropped);

                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text("Foto profil diperbarui"))
                  );
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Gagal mengambil gambar: $e'))
                  );
                }
              },
            ),

            // Pilih dari Galeri
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Pilih dari Galeri'),
              onTap: () async {
                Navigator.of(sheetContext).pop();
                try {
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery
                  );
                  if (pickedFile == null) return;

                  final File imageFile = File(pickedFile.path);
                  final File? cropped = await _cropImage(imageFile);
                  if (cropped == null) return;

                  setState(() => _profileImage = cropped);

                  await Provider.of<UmumViewModel>(
                    parentContext,
                    listen: false,
                  ).updateProfileImage(cropped);

                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text("Foto profil diperbarui"))
                  );
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Gagal memilih gambar: $e'))
                  );
                }
              },
            ),

            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
  /// Build header profil dengan avatar yang dapat diedit.
  Widget _buildProfileHeader(UmumViewModel vm) {
    Widget avatar;
    if (_profileImage != null) {
      avatar = Hero(
        tag: 'profile-image',
        child: Material(
          elevation: 4,
          shape: const CircleBorder(),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.transparent,
            backgroundImage: FileImage(_profileImage!),
          ),
        ),
      );
    } else {
      if (vm.profilePic.isNotEmpty) {
        avatar = Hero(
          tag: 'profile-image',
          child: Material(
            elevation: 4,
            shape: const CircleBorder(),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.transparent,
              backgroundImage: CachedNetworkImageProvider(vm.profilePic),
            ),
          ),
        );
      } else {
        avatar = Hero(
          tag: 'profile-image',
          child: Material(
            elevation: 4,
            shape: const CircleBorder(),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: _getAvatarColor(),
              child: Text(
                vm.namaLengkap.isNotEmpty ? vm.namaLengkap[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        );
      }
    }
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            InkWell(
              onTap: _showImageOptions,
              child: avatar,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: _showImageOptions,
                borderRadius: BorderRadius.circular(20),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Fungsi untuk mengedit username dengan mengambil nilai asli dari UmumViewModel.
  Future<void> _editUsername() async {
    final umumVM = Provider.of<UmumViewModel>(context, listen: false);
    final String currentUsername = umumVM.username; // ambil nilai asli
    final String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFieldScreen( // tanpa 'const' agar nilai dinamis diteruskan
          title: "Ubah Username",
          initialValue: currentUsername,
          description: "Username hanya boleh mengandung huruf, angka, dan underscore.",
          fieldLabel: "Username",
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _usernameController.text = result;
      });
      await Provider.of<UmumViewModel>(context, listen: false)
          .updateUserData(username: result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perubahan tersimpan'), duration: Duration(seconds: 2)),
        );
      }
    }
  }

  // Fungsi untuk mengedit nama lengkap dengan mengambil nilai asli dari UmumViewModel.
  Future<void> _editNamaLengkap() async {
    final umumVM = Provider.of<UmumViewModel>(context, listen: false);
    final String currentNamaLengkap = umumVM.namaLengkap; // ambil nilai asli
    final String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFieldScreen(
          title: "Ubah Nama Lengkap",
          initialValue: currentNamaLengkap,
          description: "Nama lengkap akan ditampilkan di profil Anda.",
          fieldLabel: "Nama Lengkap",
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _namaLengkapController.text = result;
      });
      await Provider.of<UmumViewModel>(context, listen: false)
          .updateUserData(namaLengkap: result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perubahan tersimpan'), duration: Duration(seconds: 2)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UmumViewModel>(
      create: (ctx) => UmumViewModel(apiClient: ctx.read<ApiClient>()),
      child: Consumer<UmumViewModel>(
        builder: (context, vm, _) {
          // Update controllers if empty using data from the ViewModel.
          if (vm.username.isNotEmpty && _usernameController.text.isEmpty) {
            _usernameController.text = vm.username;
          }
          if (vm.namaLengkap.isNotEmpty && _namaLengkapController.text.isEmpty) {
            _namaLengkapController.text = vm.namaLengkap;
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text("Edit Profil Umum"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildProfileHeader(vm),
                  const SizedBox(height: 24),
                  // Card untuk edit nama lengkap.
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: ListTile(
                      onTap: _editNamaLengkap,
                      leading: const Icon(Icons.account_circle, color: AppColors.primary),
                      title: const Text("Nama Lengkap", style: TextStyle(fontSize: 14, color: Colors.grey)),
                      subtitle: Text(
                        _namaLengkapController.text,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    ),
                  ),
                  // Card untuk edit username.
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: ListTile(
                      onTap: _editUsername,
                      leading: const Icon(Icons.person, color: AppColors.primary),
                      title: const Text("Username", style: TextStyle(fontSize: 14, color: Colors.grey)),
                      subtitle: Text(
                        _usernameController.text,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    ),
                  ),
                  // Card untuk field yang tidak bisa diedit (Role).
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: ListTile(
                      onTap: () {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Role tidak bisa diubah"), duration: Duration(seconds: 2)),
                          );
                        }
                      },
                      leading: const Icon(Icons.verified_user_outlined, color: Colors.grey),
                      title: const Text("Role", style: TextStyle(fontSize: 14, color: Colors.grey)),
                      subtitle: Text(
                        vm.role,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Widget untuk preview foto profil secara fullscreen.
class ProfileImagePreviewScreen extends StatelessWidget {
  final File imageFile;
  const ProfileImagePreviewScreen({Key? key, required this.imageFile}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Hero(
          tag: 'profile-image',
          child: Image.file(imageFile),
        ),
      ),
    );
  }
}

/// Generic widget for editing a field (e.g., Full Name or Username).
class EditFieldScreen extends StatefulWidget {
  final String title;
  final String initialValue;
  final String description;
  final String fieldLabel;
  final String? Function(String)? validator;

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

class _EditFieldScreenState extends State<EditFieldScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue)
      ..addListener(() {
        setState(() {});
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

  /// Convert text to Title Case.
  String _toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Save the field after validation and fade out animation.
  void _save() {
    if (_formKey.currentState!.validate()) {
      String resultText = _controller.text;
      if (widget.fieldLabel == "Nama Lengkap") {
        resultText = _toTitleCase(resultText);
      } else if (widget.fieldLabel == "Username") {
        resultText = resultText.toLowerCase();
      }
      _animationController.reverse().then((_) {
        Navigator.pop(context, resultText);
      });
    }
  }

  /// Cancel editing and return.
  void _cancel() {
    Navigator.pop(context, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0.5,
        leading: TextButton(
          onPressed: _cancel,
          child: const Text("Batal", style: TextStyle(color: AppColors.text, fontSize: 13)),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text("Simpan", style: TextStyle(color: AppColors.text, fontSize: 13, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
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
                    cursorColor: AppColors.primary,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.text),
                    maxLength: 25,
                    buildCounter: (BuildContext context, {int? currentLength, int? maxLength, bool? isFocused}) {
                      return Text(
                        '${currentLength ?? 0}/${maxLength ?? 25}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: widget.fieldLabel,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () => _controller.clear(),
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
