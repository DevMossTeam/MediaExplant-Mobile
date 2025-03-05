class AppConfig {
  // Base URL untuk API Laravel
  static const String baseUrl = 'http://127.0.0.1:8000';

  // Timeout untuk request dalam milidetik
  static const int connectTimeout = 5000; // 5 detik
  static const int receiveTimeout = 5000; // 5 detik

  // Header default untuk request API
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}