import '../../domain/entities/notification.dart';

class NotificationModel extends Notification {
  NotificationModel({
    required String id,
    required String title,
    required String body,
    required DateTime date,
  }) : super(
          id: id,
          title: title,
          body: body,
          date: date,
        );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'].toString(),
      title: json['title'],
      body: json['body'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'date': date.toIso8601String(),
    };
  }
}
