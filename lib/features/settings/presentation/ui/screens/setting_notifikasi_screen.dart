import 'package:flutter/material.dart';
import 'package:mediaexplant/core/utils/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingNotifikasiScreen extends StatefulWidget {
  const SettingNotifikasiScreen({Key? key}) : super(key: key);

  @override
  State<SettingNotifikasiScreen> createState() =>
      _SettingNotifikasiScreenState();
}

class _SettingNotifikasiScreenState extends State<SettingNotifikasiScreen> {
  bool _pushNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('pushNotifications') ?? true;
    });
  }

  Future<void> _saveNotificationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pushNotifications', value);
  }

  Future<bool> _requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();
    return status.isGranted;
  }

  Widget _buildNotificationOption({
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primary,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.text,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.text.withOpacity(0.8),
          ),
        ),
        trailing: Switch(
          value: value,
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Notifikasi'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 16),
            _buildNotificationOption(
              icon: Icons.notifications_active_outlined,
              title: 'Notifikasi Push',
              description: 'Terima notifikasi langsung di perangkat Anda',
              value: _pushNotifications,
              onChanged: (bool value) async {
                if (value) {
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Izin notifikasi ditolak'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } else {
                  setState(() {
                    _pushNotifications = false;
                  });
                  _saveNotificationPreference(false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifikasi dinonaktifkan'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
