import 'package:flutter/material.dart';
import 'package:mediaexplant/features/notifications/domain/entities/notification.dart'
    as app_notification;
import 'package:mediaexplant/features/notifications/domain/usecases/get_notifications.dart';

class NotificationsViewModel extends ChangeNotifier {
  final GetNotifications getNotifications;

  NotificationsViewModel({required this.getNotifications});

  List<app_notification.Notification> _notifications = [];
  List<app_notification.Notification> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notifications = await getNotifications.execute();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}