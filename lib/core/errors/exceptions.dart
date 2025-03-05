class ServerException implements Exception {
  final String message;
  ServerException([this.message = "Server Error"]);
  
  @override
  String toString() => "ServerException: $message";
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = "Cache Error"]);
  
  @override
  String toString() => "CacheException: $message";
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = "No Internet Connection"]);
  
  @override
  String toString() => "NetworkException: $message";
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = "Unauthorized"]);
  
  @override
  String toString() => "UnauthorizedException: $message";
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = "Resource Not Found"]);
  
  @override
  String toString() => "NotFoundException: $message";
}

class BadRequestException implements Exception {
  final String message;
  BadRequestException([this.message = "Bad Request"]);
  
  @override
  String toString() => "BadRequestException: $message";
}

class UnknownException implements Exception {
  final String message;
  UnknownException([this.message = "An unknown error occurred"]);
  
  @override
  String toString() => "UnknownException: $message";
}