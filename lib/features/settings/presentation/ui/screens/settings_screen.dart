import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart'; // Ganti dengan path yang sesuai

/// Tampilan halaman Settings dengan desain modern dan terstruktur.
/// Terdapat dua bagian utama: "Pengaturan" dan "Pusat Informasi", ditambah
/// dengan section "Lainnya" untuk opsi tambahan seperti Logout, dan footer.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan background gradient yang menggunakan AppColors.primary.
      appBar: AppBar(
        centerTitle: true,
        elevation: 4,
        title: const Text("Settings"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                // Variasi warna dengan sedikit gradasi ke hitam untuk kesan dinamis.
                Color.lerp(AppColors.primary, Colors.black, 0.1) ?? AppColors.primary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      // Body menggunakan background gradient berbasis AppColors.background.
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background,
              Color.lerp(AppColors.background, Colors.grey, 0.05) ?? AppColors.background,
            ],
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
            const SettingItem(
              icon: Icons.settings,
              title: "Umum",
              routeName: '/settings/umum',
            ),
            const SettingItem(
              icon: Icons.lock,
              title: "Keamanan",
              routeName: '/settings/keamanan',
            ),
            const SettingItem(
              icon: Icons.notifications,
              title: "Notifikasi",
              routeName: '/settings/setting_notifikasi',
            ),
            const SizedBox(height: 24),
            // Section: Pusat Informasi
            const SectionHeader(title: "Pusat Informasi"),
            const SizedBox(height: 8),
            const SettingItem(
              icon: Icons.info,
              title: "Tentang",
              routeName: '/settings/tentang',
            ),
            const SettingItem(
              icon: Icons.help,
              title: "Pusat Bantuan",
              routeName: '/settings/pusat_bantuan',
            ),
            const SettingItem(
              icon: Icons.contact_mail,
              title: "Hubungi",
              routeName: '/settings/hubungi',
            ),
            const SizedBox(height: 24),
            // Section: Lainnya (contoh Logout)
            const SectionHeader(title: "Lainnya"),
            const SizedBox(height: 8),
            const SettingItem(
              icon: Icons.logout,
              title: "Logout",
              routeName: '/settings/logout',
            ),
            const SizedBox(height: 24),
            // Footer: Versi Aplikasi
            Center(
              child: Text(
                "Versi 1.0.0",
                style: TextStyle(fontSize: 14, color: AppColors.text.withOpacity(0.6)),
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
            color: AppColors.primary,
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
        // Icon ditempatkan dalam CircleAvatar dengan background yang merupakan
        // turunan warna utama (AppColors.primary) agar konsisten.
        leading: CircleAvatar(
          backgroundColor: Color.lerp(AppColors.primary, Colors.white, 0.8) ?? AppColors.background,
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.text.withOpacity(0.6),
        ),
        onTap: () {
          // Jika item logout, navigasikan ke SplashScreen (atau halaman Sign In)
          if (routeName == '/settings/logout') {
            Navigator.pushReplacementNamed(context, '/');
          } else {
            Navigator.pushNamed(context, routeName);
          }
        },
      ),
    );
  }
}
