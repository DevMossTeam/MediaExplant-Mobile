import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<List<Notification>> getNotifications();
}
