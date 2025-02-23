import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingItem(
            context,
            icon: Icons.contact_mail,
            title: "Hubungi",
            routeName: '/settings/hubungi',
          ),
          _buildSettingItem(
            context,
            icon: Icons.lock,
            title: "Keamanan",
            routeName: '/settings/keamanan',
          ),
          _buildSettingItem(
            context,
            icon: Icons.notifications,
            title: "Setting Notifikasi",
            routeName: '/settings/setting_notifikasi',
          ),
          _buildSettingItem(
            context,
            icon: Icons.info,
            title: "Tentang",
            routeName: '/settings/tentang',
          ),
          _buildSettingItem(
            context,
            icon: Icons.help,
            title: "Pusat Bantuan",
            routeName: '/settings/pusat_bantuan',
          ),
          _buildSettingItem(
            context,
            icon: Icons.settings,
            title: "Umum",
            routeName: '/settings/umum',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context,
      {required IconData icon,
      required String title,
      required String routeName}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
      ),
    );
  }
}