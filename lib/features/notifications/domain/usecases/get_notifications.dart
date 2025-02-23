import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications({required this.repository});

  Future<List<Notification>> execute() async {
    return await repository.getNotifications();
  }
}
