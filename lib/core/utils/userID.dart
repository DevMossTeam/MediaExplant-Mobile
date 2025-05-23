import 'auth_storage.dart';

String? userLogin;
Future<void> loadUserLogin() async {
  final userData = await AuthStorage.getUserData();
  userLogin = userData['uid'];
}
