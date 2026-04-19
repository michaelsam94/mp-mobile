/// Validates Egyptian mobile numbers entered in the local field (no country code).
/// Must be 11 digits and start with 010, 011, 012, or 015.
abstract final class EgyptPhoneValidator {
  static final RegExp _local11 = RegExp(r'^01[0125]\d{8}$');

  /// [localNumber] is the text from the phone field only (digits; spaces ignored).
  static bool isValidLocal11Digits(String localNumber) {
    final digits = localNumber.replaceAll(RegExp(r'\D'), '');
    return _local11.hasMatch(digits);
  }
}
