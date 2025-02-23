import 'package:flutter/material.dart';

class SettingNotifikasiScreen extends StatefulWidget {
  const SettingNotifikasiScreen({super.key});

  @override
  State<SettingNotifikasiScreen> createState() => _SettingNotifikasiScreenState();
}

class _SettingNotifikasiScreenState extends State<SettingNotifikasiScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = false;
  bool _soundNotifications = true;

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
          // Notifikasi Push
          SwitchListTile(
            title: const Text('Notifikasi Push'),
            subtitle: const Text('Terima notifikasi langsung di perangkat Anda'),
            value: _pushNotifications,
            onChanged: (bool value) {
              setState(() {
                _pushNotifications = value;
              });
            },
            activeColor: Theme.of(context).primaryColor,
          ),
          // Notifikasi Email
          SwitchListTile(
            title: const Text('Notifikasi Email'),
            subtitle: const Text('Dapatkan pembaruan melalui email'),
            value: _emailNotifications,
            onChanged: (bool value) {
              setState(() {
                _emailNotifications = value;
              });
            },
            activeColor: Theme.of(context).primaryColor,
          ),
          // Notifikasi SMS
          SwitchListTile(
            title: const Text('Notifikasi SMS'),
            subtitle: const Text('Terima notifikasi melalui SMS'),
            value: _smsNotifications,
            onChanged: (bool value) {
              setState(() {
                _smsNotifications = value;
              });
            },
            activeColor: Theme.of(context).primaryColor,
          ),
          // Suara Notifikasi
          SwitchListTile(
            title: const Text('Suara Notifikasi'),
            subtitle: const Text('Aktifkan atau nonaktifkan suara notifikasi'),
            value: _soundNotifications,
            onChanged: (bool value) {
              setState(() {
                _soundNotifications = value;
              });
            },
            activeColor: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 24),
          // Tombol Simpan Pengaturan
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Simulasikan penyimpanan pengaturan notifikasi
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pengaturan notifikasi telah disimpan')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Simpan Pengaturan',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}