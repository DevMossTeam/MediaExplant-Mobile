import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/settings/logic/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 4,
        backgroundColor: AppColors.primary,
        title: const Text('Settings'),
      ),
      body: AnimatedBuilder(
        animation: vm,
        builder: (context, _) {
          // Show loading indicator while checking auth state
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.background,
                  Color.lerp(AppColors.background, Colors.grey, 0.05)!,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              children: [
                // Section Pengaturan (both cases)
                const SectionHeader(title: 'Pengaturan'),
                const SizedBox(height: 8),
                if (vm.isLoggedIn) ...[
                  const SettingItem(
                    icon: Icons.settings,
                    title: 'Umum',
                    routeName: '/settings/umum',
                  ),
                  const SettingItem(
                    icon: Icons.lock,
                    title: 'Keamanan',
                    routeName: '/settings/keamanan',
                  ),
                ],
                // Always show notifications
                const SettingItem(
                  icon: Icons.notifications,
                  title: 'Notifikasi',
                  routeName: '/settings/setting_notifikasi',
                ),
                const SizedBox(height: 24),

                // Section Pusat Informasi
                const SectionHeader(title: 'Pusat Informasi'),
                const SizedBox(height: 8),
                const SettingItem(
                  icon: Icons.info,
                  title: 'Tentang',
                  routeName: '/settings/tentang',
                ),
                const SettingItem(
                  icon: Icons.help,
                  title: 'Pusat Bantuan',
                  routeName: '/settings/pusat_bantuan',
                ),
                const SettingItem(
                  icon: Icons.contact_mail,
                  title: 'Hubungi',
                  routeName: '/settings/hubungi',
                ),
                const SizedBox(height: 24),

                // Section Lainnya (Logout jika login)
                if (vm.isLoggedIn) ...[
                  const SectionHeader(title: 'Lainnya'),
                  const SizedBox(height: 8),
                  SettingItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () => vm.logout(context),
                  ),
                  const SizedBox(height: 24),
                ],

                // Footer: Versi Aplikasi
                Center(
                  child: Text(
                    'Versi 1.0.0',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.text.withOpacity(0.6),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

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

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? routeName;
  final VoidCallback? onTap;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    this.routeName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor:
              Color.lerp(AppColors.primary, Colors.white, 0.8)!,
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        trailing: onTap == null && routeName != null
            ? Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.text.withOpacity(0.6),
              )
            : null,
        onTap: onTap ?? () {
          if (routeName != null) Navigator.pushNamed(context, routeName!);
        },
      ),
    );
  }
}
