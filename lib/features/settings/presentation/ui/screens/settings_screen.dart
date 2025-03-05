import 'package:flutter/material.dart';

/// Tampilan halaman Settings dengan desain modern dan terstruktur.
/// Terdapat dua bagian utama: "Pengaturan" dan "Pusat Informasi", ditambah
/// dengan section "Lainnya" untuk opsi tambahan seperti Logout, dan footer.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan background gradient yang memberikan kesan modern.
      appBar: AppBar(
        centerTitle: true,
        elevation: 4,
        title: const Text("Settings"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      // Body menggunakan background gradient ringan agar tampilan tidak datar.
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF2F2F2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // Section: Pengaturan
            const SectionHeader(title: "Pengaturan"),
            const SizedBox(height: 8),
            SettingItem(
              icon: Icons.settings,
              title: "Umum",
              routeName: '/settings/umum',
            ),
            SettingItem(
              icon: Icons.lock,
              title: "Keamanan",
              routeName: '/settings/keamanan',
            ),
            SettingItem(
              icon: Icons.notifications,
              title: "Setting Notifikasi",
              routeName: '/settings/setting_notifikasi',
            ),
            const SizedBox(height: 24),
            // Section: Pusat Informasi
            const SectionHeader(title: "Pusat Informasi"),
            const SizedBox(height: 8),
            SettingItem(
              icon: Icons.info,
              title: "Tentang",
              routeName: '/settings/tentang',
            ),
            SettingItem(
              icon: Icons.help,
              title: "Pusat Bantuan",
              routeName: '/settings/pusat_bantuan',
            ),
            SettingItem(
              icon: Icons.contact_mail,
              title: "Hubungi",
              routeName: '/settings/hubungi',
            ),
            const SizedBox(height: 24),
            // Section: Lainnya (contoh Logout)
            const SectionHeader(title: "Lainnya"),
            const SizedBox(height: 8),
            SettingItem(
              icon: Icons.logout,
              title: "Logout",
              routeName: '/settings/logout',
            ),
            const SizedBox(height: 24),
            // Footer: Versi Aplikasi
            const Center(
              child: Text(
                "Versi 1.0.0",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Widget SectionHeader memberikan tampilan konsisten untuk judul tiap section.
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D47A1),
          ),
    );
  }
}

/// Widget SettingItem merepresentasikan satu item pengaturan.
/// Setiap item ditampilkan dalam bentuk Card dengan ListTile yang telah dihias.
class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String routeName;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // Icon ditempatkan dalam CircleAvatar dengan latar transparan.
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
      ),
    );
  }
}
