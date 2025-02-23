import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  NotificationRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await client.get(Uri.parse('$baseUrl/notifications'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Gagal memuat notifikasi');
    }
  }
}
