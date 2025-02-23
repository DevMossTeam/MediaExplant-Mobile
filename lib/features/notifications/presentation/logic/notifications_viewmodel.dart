import 'package:flutter/material.dart' hide Notification;
import 'package:mediaexplant/features/notifications/domain/entities/notification.dart';
import 'package:mediaexplant/features/notifications/domain/usecases/get_notifications.dart';

class NotificationsViewModel extends ChangeNotifier {
  final GetNotifications getNotifications;

  NotificationsViewModel({required this.getNotifications});

  List<Notification> _notifications = [];
  List<Notification> get notifications => _notifications;

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