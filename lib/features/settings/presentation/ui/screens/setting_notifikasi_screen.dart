import 'package:flutter/material.dart';

class SettingNotifikasiScreen extends StatefulWidget {
  const SettingNotifikasiScreen({super.key});

  @override
  State<SettingNotifikasiScreen> createState() => _SettingNotifikasiScreenState();
}

class _SettingNotifikasiScreenState extends State<SettingNotifikasiScreen> {
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Notifikasi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Judul Halaman
          const Text(
            'Pengaturan Notifikasi',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Atur preferensi notifikasi Anda di bawah ini:',
            style: TextStyle(fontSize: 16),
          ),
          const Divider(height: 32, thickness: 1),
          // Notifikasi Push dengan snackbar saat perubahan
          SwitchListTile(
            title: const Text('Notifikasi Push'),
            subtitle: const Text('Terima notifikasi langsung di perangkat Anda'),
            value: _pushNotifications,
            onChanged: (bool value) {
              setState(() {
                _pushNotifications = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Notifikasi ${value ? 'diaktifkan' : 'dinonaktifkan'}',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}