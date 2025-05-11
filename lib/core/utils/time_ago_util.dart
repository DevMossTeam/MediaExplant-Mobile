import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart' as timeago_id;

/// Inisialisasi locale Indonesia (panggil ini sekali saja, misalnya di `main`)
void initializeTimeAgo() {
  timeago.setLocaleMessages('id', timeago_id.IdMessages());
}

String timeAgoFormat(DateTime dateTime) {
  return timeago.format(dateTime, locale: 'id');
}

/// Versi dengan fallback jika `dateTime` null
String timeAgoFormatNullable(DateTime? dateTime) {
  if (dateTime == null) return '-';
  return timeago.format(dateTime, locale: 'id');
}
