import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository); // Menghapus `{required this.repository}` agar lebih ringkas

  Future<List<Notification>> execute() {
    return repository.getNotifications(); // Menghapus `await` yang tidak perlu
  }
}