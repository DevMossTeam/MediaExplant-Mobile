import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';

// 1) Import the Notifikasi ViewModel
import 'package:mediaexplant/features/settings/logic/setting_notifikasi_viewmodel.dart';
import 'package:mediaexplant/features/settings/logic/settings_viewmodel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingNotifikasiViewModel notifVm;
  late SettingsViewModel vm;

  @override
  void initState() {
    super.initState();
    // Tidak perlu memanggil loadPreferences() karena sudah di constructor ViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifVm = context.read<SettingNotifikasiViewModel>();
    });
  }

  @override
  Widget build(BuildContext context) {
    vm = context.watch<SettingsViewModel>();
    notifVm = context.watch<SettingNotifikasiViewModel>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 4,
        backgroundColor: AppColors.primary,
        title: const Text('Settings'),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([vm, notifVm]),
        builder: (context, _) {
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

                _NotificationToggleItem(
                  isEnabled: notifVm.pushNotifications,
                  isLoading: !notifVm.isInitialized || notifVm.isProcessing,
                  // Kirim context agar ViewModel bisa memunculkan Snackbar
                  onChanged: (value) => notifVm.updatePushNotifications(context, value),
                ),

                const SizedBox(height: 24),

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

/// Perubahan: menerima `isLoading` yang merupakan gabungan
/// dari !isInitialized atau isProcessing
class _NotificationToggleItem extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final ValueChanged<bool> onChanged;

  const _NotificationToggleItem({
    super.key,
    required this.isEnabled,
    required this.isLoading,
    required this.onChanged,
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
          backgroundColor: Color.lerp(AppColors.primary, Colors.white, 0.8)!,
          child: Icon(Icons.notifications, color: AppColors.primary),
        ),
        title: Text(
          'Notifikasi',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        trailing: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            : Switch(
                value: isEnabled,
                onChanged: onChanged,
                activeColor: AppColors.primary,
              ),
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
        onTap: onTap ??
            () {
              if (routeName != null) Navigator.pushNamed(context, routeName!);
            },
      ),
    );
  }
}
