class ApiConnectionException implements Exception {
  final String cause;
  ApiConnectionException(this.cause);
}
