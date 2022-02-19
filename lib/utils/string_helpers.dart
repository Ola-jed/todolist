extension StringHelpers on String {
  bool isBlank() {
    return this.trim().isEmpty;
  }
}