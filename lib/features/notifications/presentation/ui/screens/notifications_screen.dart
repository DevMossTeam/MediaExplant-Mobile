import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/notifications_viewmodel.dart';
import '../../widgets/notification_item.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastikan NotificationsViewModel sudah disediakan di widget tree
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: Consumer<NotificationsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.notifications.isEmpty) {
            return const Center(child: Text('Tidak ada notifikasi'));
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                await viewModel.fetchNotifications();
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: viewModel.notifications.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final notification = viewModel.notifications[index];
                  return NotificationItem(notification: notification);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
