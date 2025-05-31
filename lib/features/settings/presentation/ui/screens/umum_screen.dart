import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/core/utils/auth_storage.dart';
import 'package:provider/provider.dart';

// Ganti path berikut sesuai lokasi UmumViewModel-mu:
import 'package:mediaexplant/features/settings/logic/umum_viewmodel.dart';

/// Helper untuk membuat MaterialColor dari Color biasa
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
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
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
  late TextEditingController _usernameController;
  late TextEditingController _namaLengkapController;

  // File lokal untuk preview sebelum upload
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

  /// Warna latar avatar berdasarkan huruf pertama nama lengkap
  Color _getAvatarColor(String namaLengkap) {
    if (namaLengkap.isEmpty) return Colors.grey;
    int code = namaLengkap.trim()[0].toUpperCase().codeUnitAt(0);
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

  /// Crop gambar seleksi
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

  /// Tampilkan bottom sheet opsi foto
  Future<void> _showImageOptions() async {
    final vm       = context.read<UmumViewModel>();
    final scaffold = ScaffoldMessenger.of(context);

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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

// Hapus Foto (jika lokal ada atau server ada)
if (_profileImage != null || vm.profilePic.isNotEmpty)
  ListTile(
    leading: const Icon(Icons.delete, color: AppColors.primary),
    title: const Text('Hapus Foto'),
    onTap: () async {
      Navigator.pop(ctx);

      // 1) Panggil API untuk hapus di server
      await vm.deleteProfileImage();

      // 2) Segera refresh data di ViewModel (agar vm.profilePic jadi "")
      await vm.loadUserData();

      // 3) Hapus juga file lokal agar _buildProfileHeader tahu tidak ada gambar
      setState(() => _profileImage = null);

      // 4) Beri umpan balik ke user
      scaffold.showSnackBar(
        const SnackBar(
          content: Text("Foto profil dihapus"),
          duration: Duration(seconds: 2),
        ),
      );
    },
  ),


              // Ambil dari Kamera
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('Ambil dari Kamera'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picked =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (picked == null) return;
                  final cropped = await _cropImage(File(picked.path));
                  if (cropped == null) return;
                  await vm.updateProfileImage(cropped);
                  setState(() => _profileImage = cropped);
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text("Foto profil diperbarui"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),

              // Pilih dari Galeri
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picked =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (picked == null) return;
                  final cropped = await _cropImage(File(picked.path));
                  if (cropped == null) return;
                  await vm.updateProfileImage(cropped);
                  setState(() => _profileImage = cropped);
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text("Foto profil diperbarui"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  /// Header profil dengan avatar yang menggunakan profileImageProvider
  Widget _buildProfileHeader(UmumViewModel vm) {
    // Cek apakah user sudah memilih file lokal:
    final bool hasLocal = _profileImage != null;
    // Cek apakah ada foto dari server (base64 atau URL):
    final bool hasNetwork = vm.profilePic.isNotEmpty;

    // Jika ada lokal, gunakan FileImage; jika hanya server, pakai vm.profileImageProvider; jika tidak ada sama sekali, imageProvider == null
    ImageProvider? imageProvider;
    if (hasLocal) {
      imageProvider = FileImage(_profileImage!);
    } else if (hasNetwork) {
      imageProvider = vm.profileImageProvider;
    } else {
      imageProvider = null;
    }

    // Jika imageProvider != null, boleh preview; kalau tidak, preview di-disable
    final avatar = Hero(
      tag: 'profile-image',
      child: Material(
        elevation: 4,
        shape: const CircleBorder(),
        child: CircleAvatar(
          radius: 60,
          backgroundColor: (imageProvider != null)
              ? Colors.transparent
              : _getAvatarColor(vm.namaLengkap),
          backgroundImage: imageProvider,
          child: imageProvider == null
              ? Text(
                  vm.namaLengkap.isNotEmpty
                      ? vm.namaLengkap.trim()[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
      ),
    );

    // Jika ada foto, bungkus dengan GestureDetector untuk preview; kalau tidak, hanya tampilkan avatar biasa
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            if (imageProvider != null)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileImagePreviewScreen(
                        imageProvider: imageProvider!,
                        heroTag:       'profile-image',
                      ),
                    ),
                  );
                },
                child: avatar,
              )
            else
              avatar,

            // Tombol edit kamera (tetap ditampilkan)
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: _showImageOptions,
                borderRadius: BorderRadius.circular(20),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.camera_alt,
                      color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Edit Username: ambil current value, buka EditFieldScreen, panggil updateUserData
  Future<void> _editUsername() async {
    final umumVM = Provider.of<UmumViewModel>(context, listen: false);
    final String currentUsername = umumVM.username;
    final String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFieldScreen(
          title: "Ubah Username",
          initialValue: currentUsername,
          description:
              "Username hanya boleh mengandung huruf, angka, dan underscore.",
          fieldLabel: "Username",
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _usernameController.text = result;
      });
      await umumVM.updateUserData(username: result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perubahan username tersimpan'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Edit Nama Lengkap: mirip _editUsername
  Future<void> _editNamaLengkap() async {
    final umumVM = Provider.of<UmumViewModel>(context, listen: false);
    final String currentNamaLengkap = umumVM.namaLengkap;
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
      await umumVM.updateUserData(namaLengkap: result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perubahan nama lengkap tersimpan'),
            duration: Duration(seconds: 2),
          ),
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
          // Set initial text di controller hanya sekali
          if (vm.username.isNotEmpty && _usernameController.text.isEmpty) {
            _usernameController.text = vm.username;
          }
          if (vm.namaLengkap.isNotEmpty &&
              _namaLengkapController.text.isEmpty) {
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

                  // Card untuk edit nama lengkap
                  Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: ListTile(
                      onTap: _editNamaLengkap,
                      leading: const Icon(Icons.account_circle,
                          color: AppColors.primary),
                      title: const Text("Nama Lengkap",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                      subtitle: Text(
                        _namaLengkapController.text,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(Icons.chevron_right,
                          color: Colors.grey),
                    ),
                  ),

                  // Card untuk edit username
                  Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: ListTile(
                      onTap: _editUsername,
                      leading:
                          const Icon(Icons.person, color: AppColors.primary),
                      title: const Text("Username",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                      subtitle: Text(
                        _usernameController.text,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(Icons.chevron_right,
                          color: Colors.grey),
                    ),
                  ),

                  // Card untuk field yang tidak bisa diedit (Role)
                  Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: ListTile(
                      onTap: () {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Role tidak bisa diubah"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      leading: const Icon(Icons.verified_user_outlined,
                          color: Colors.grey),
                      title: const Text("Role",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                      subtitle: Text(
                        vm.role,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
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

/// Halaman preview foto profil fullscreen.
class ProfileImagePreviewScreen extends StatelessWidget {
  final ImageProvider imageProvider;
  final String heroTag;

  const ProfileImagePreviewScreen({
    Key? key,
    required this.imageProvider,
    required this.heroTag,
  }) : super(key: key);

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
          tag: heroTag,
          child: Image(
            image: imageProvider,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

/// Layar untuk mengedit satu field (username atau nama lengkap).
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

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();

    // Jalankan validasi awal jika fieldLabel == "Username"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final umumVM = context.read<UmumViewModel>();
      if (widget.fieldLabel == "Username") {
        umumVM.onUsernameChanged(_controller.text);
      }
      _controller.addListener(() {
        setState(() {});
        if (widget.fieldLabel == "Username") {
          umumVM.onUsernameChanged(_controller.text);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

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

  void _cancel() {
    Navigator.pop(context, null);
  }

  @override
  Widget build(BuildContext context) {
    final umumVM = context.watch<UmumViewModel>();
    final isFormValid = _formKey.currentState?.validate() ?? false;

    final canSave = isFormValid &&
        (widget.fieldLabel != "Username" ||
            (!umumVM.isCheckingUsername && umumVM.isUsernameAvailable));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0.5,
        leading: TextButton(
          onPressed: _cancel,
          child: const Text("Batal",
              style: TextStyle(color: AppColors.text, fontSize: 13)),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
              color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: canSave ? _save : null,
            child: const Text("Simpan",
                style: TextStyle(
                    color: AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                    maxLength: 25,
                    buildCounter: (
                      BuildContext context, {
                      required int currentLength,
                      int? maxLength,
                      required bool isFocused,
                    }) {
                      return Text(
                        '$currentLength/${maxLength ?? 25}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: widget.fieldLabel,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      suffixIcon: widget.fieldLabel == "Username"
                          ? _controller.text.isEmpty
                              ? null
                              : (umumVM.isCheckingUsername
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : (umumVM.isUsernameAvailable
                                      ? const Icon(Icons.check,
                                          color: Colors.green)
                                      : const Icon(Icons.close,
                                          color: Colors.red)))
                          : (_controller.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.grey),
                                  onPressed: () => _controller.clear(),
                                )
                              : null),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Tidak boleh kosong";
                      }
                      if (widget.validator != null) {
                        final v = widget.validator!(value);
                        if (v != null) return v;
                      }
                      if (widget.fieldLabel == "Username") {
                        if (umumVM.isCheckingUsername) {
                          return "Sedang memeriksa...";
                        }
                        if (!umumVM.isUsernameAvailable) {
                          return "Username sudah terpakai";
                        }
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
