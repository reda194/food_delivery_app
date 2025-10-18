/// Comprehensive input validation utilities
class InputValidators {
  InputValidators._();

  /// Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Password validation with strong requirements
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Phone validation (international format)
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final phoneRegex = RegExp(r'^\+?[1-9]\d{9,14}$');
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Name validation
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  /// Address validation
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }

    if (value.trim().length < 10) {
      return 'Please enter a complete address';
    }

    return null;
  }

  /// Zip code validation (US format)
  static String? validateZipCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Zip code is required';
    }

    if (!RegExp(r'^\d{5}(-\d{4})?$').hasMatch(value.trim())) {
      return 'Invalid zip code';
    }

    return null;
  }

  /// Credit card number validation (Luhn algorithm)
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }

    final cleaned = value.replaceAll(RegExp(r'\s'), '');

    if (cleaned.length < 13 || cleaned.length > 19) {
      return 'Invalid card number length';
    }

    if (!_luhnCheck(cleaned)) {
      return 'Invalid card number';
    }

    return null;
  }

  /// Luhn algorithm for credit card validation
  static bool _luhnCheck(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  /// CVV validation
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }

    if (!RegExp(r'^\d{3,4}$').hasMatch(value)) {
      return 'Invalid CVV';
    }

    return null;
  }

  /// Expiry date validation (MM/YY format)
  static String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }

    final parts = value.split('/');
    if (parts.length != 2) {
      return 'Invalid format. Use MM/YY';
    }

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) {
      return 'Invalid date';
    }

    if (month < 1 || month > 12) {
      return 'Invalid month';
    }

    final now = DateTime.now();
    final expiry = DateTime(2000 + year, month);

    if (expiry.isBefore(now)) {
      return 'Card has expired';
    }

    return null;
  }

  /// URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value.trim())) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Number validation
  static String? validateNumber(String? value, {int? min, int? max}) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    final number = int.tryParse(value.trim());
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (min != null && number < min) {
      return 'Value must be at least $min';
    }

    if (max != null && number > max) {
      return 'Value must be at most $max';
    }

    return null;
  }

  /// Price validation
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value.trim());
    if (price == null) {
      return 'Please enter a valid price';
    }

    if (price < 0) {
      return 'Price cannot be negative';
    }

    return null;
  }
}
