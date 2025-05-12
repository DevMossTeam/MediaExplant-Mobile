import 'package:timeago/timeago.dart' as timeago;

import 'package:timeago/timeago.dart' as timeago;

class CustomIdMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => ''; // kosong agar tidak jadi "baru saja yang lalu"
  @override
  String suffixFromNow() => 'dari sekarang';
  @override
  String lessThanOneMinute(int seconds) => 'baru saja'; // <- di sini diganti
  @override
  String aboutAMinute(int minutes) => '1 menit';
  @override
  String minutes(int minutes) => '$minutes menit';
  @override
  String aboutAnHour(int minutes) => '1 jam';
  @override
  String hours(int hours) => '$hours jam';
  @override
  String aDay(int hours) => '1 hari';
  @override
  String days(int days) => '$days hari';
  @override
  String aboutAMonth(int days) => '1 bulan';
  @override
  String months(int months) => '$months bulan';
  @override
  String aboutAYear(int year) => '1 tahun';
  @override
  String years(int years) => '$years tahun';
  @override
  String wordSeparator() => ' ';
}

void initializeTimeAgo() {
  timeago.setLocaleMessages('id', CustomIdMessages());
}

String timeAgoFormat(DateTime dateTime) {
  final now = DateTime.now().toLocal();
  return timeago.format(
    dateTime.toLocal(),
    locale: 'id',
    clock: now,
    allowFromNow: false,
  );
}

/// Versi dengan fallback jika `dateTime` null
String timeAgoFormatNullable(DateTime? dateTime) {
  if (dateTime == null) return '-';
  return timeago.format(dateTime, locale: 'id');
}
