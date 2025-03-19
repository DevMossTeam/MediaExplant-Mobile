import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mediaexplant/core/utils/app_colors.dart'; // Sesuaikan path jika diperlukan

class SettingNotifikasiScreen extends StatefulWidget {
  const SettingNotifikasiScreen({Key? key}) : super(key: key);

  @override
  State<SettingNotifikasiScreen> createState() => _SettingNotifikasiScreenState();
}

class _SettingNotifikasiScreenState extends State<SettingNotifikasiScreen> {
  bool _pushNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  // Ambil nilai notifikasi dari SharedPreferences
  Future<void> _loadNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('pushNotifications') ?? true;
    });
  }

  // Simpan nilai notifikasi ke SharedPreferences
  Future<void> _saveNotificationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pushNotifications', value);
  }

  // Meminta izin notifikasi
  Future<bool> _requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();
    return status.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Notifikasi'),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Judul Halaman
          Text(
            'Pengaturan Notifikasi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Atur preferensi notifikasi Anda di bawah ini:',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.text,
            ),
          ),
          const Divider(height: 32, thickness: 1),
          // SwitchListTile dengan permintaan izin saat diaktifkan
          SwitchListTile(
            title: Text(
              'Notifikasi Push',
              style: TextStyle(
                color: AppColors.text,
              ),
            ),
            subtitle: Text(
              'Terima notifikasi langsung di perangkat Anda',
              style: TextStyle(
                color: AppColors.text.withOpacity(0.8),
              ),
            ),
            value: _pushNotifications,
            activeColor: AppColors.primary,
            onChanged: (bool value) async {
              if (value) {
                // Jika user mengaktifkan, minta izin notifikasi
                bool granted = await _requestNotificationPermission();
                if (granted) {
                  setState(() {
                    _pushNotifications = true;
                  });
                  _saveNotificationPreference(true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifikasi diizinkan'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  // Jika izin tidak diberikan, tampilkan pesan dan jangan ubah state
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Izin notifikasi ditolak'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } else {
                // Jika user menonaktifkan notifikasi
                setState(() {
                  _pushNotifications = false;
                });
                _saveNotificationPreference(false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notifikasi tidak diizinkan'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}