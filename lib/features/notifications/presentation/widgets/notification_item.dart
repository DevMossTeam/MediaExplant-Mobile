import 'package:flutter/material.dart' hide Notification;
import 'package:mediaexplant/features/notifications/domain/entities/notification.dart';

class NotificationItem extends StatelessWidget {
  final Notification notification;
  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          notification.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(notification.body),
        ),
        trailing: Text(
          _formatDate(notification.date),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Format tanggal sederhana, Anda dapat menggunakan package intl untuk format yang lebih lengkap
    return '${date.day}/${date.month}/${date.year}';
  }
}