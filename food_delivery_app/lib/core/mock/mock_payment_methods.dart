/// Mock payment methods data for food delivery app
class MockPaymentMethods {
  static final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'pm_1',
      'userId': 'user_123',
      'type': 'credit_card',
      'brand': 'Visa',
      'last4': '4242',
      'expiryMonth': 12,
      'expiryYear': 2025,
      'holderName': 'John Doe',
      'isDefault': true,
      'createdAt': '2024-01-01T10:00:00Z',
    },
    {
      'id': 'pm_2',
      'userId': 'user_123',
      'type': 'credit_card',
      'brand': 'Mastercard',
      'last4': '5555',
      'expiryMonth': 8,
      'expiryYear': 2026,
      'holderName': 'John Doe',
      'isDefault': false,
      'createdAt': '2024-01-05T14:30:00Z',
    },
    {
      'id': 'pm_3',
      'userId': 'user_123',
      'type': 'debit_card',
      'brand': 'Visa',
      'last4': '6789',
      'expiryMonth': 3,
      'expiryYear': 2027,
      'holderName': 'John Doe',
      'isDefault': false,
      'createdAt': '2024-01-10T09:15:00Z',
    },
    {
      'id': 'pm_4',
      'userId': 'user_123',
      'type': 'paypal',
      'email': 'john.doe@example.com',
      'isDefault': false,
      'createdAt': '2024-01-12T16:20:00Z',
    },
  ];

  /// Get default payment method
  static Map<String, dynamic>? getDefaultPaymentMethod() {
    try {
      return paymentMethods.firstWhere((pm) => pm['isDefault'] == true);
    } catch (e) {
      return paymentMethods.isNotEmpty ? paymentMethods.first : null;
    }
  }

  /// Get payment method by ID
  static Map<String, dynamic>? getPaymentMethodById(String paymentMethodId) {
    try {
      return paymentMethods
          .firstWhere((pm) => pm['id'] == paymentMethodId);
    } catch (e) {
      return null;
    }
  }

  /// Add new payment method
  static Map<String, dynamic> addPaymentMethod(
      Map<String, dynamic> paymentData) {
    final newPaymentMethod = {
      'id': 'pm_${DateTime.now().millisecondsSinceEpoch}',
      'userId': 'user_123',
      ...paymentData,
      'createdAt': DateTime.now().toIso8601String(),
    };
    paymentMethods.add(newPaymentMethod);
    return newPaymentMethod;
  }

  /// Delete payment method
  static bool deletePaymentMethod(String paymentMethodId) {
    try {
      paymentMethods.removeWhere((pm) => pm['id'] == paymentMethodId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Set default payment method
  static bool setDefaultPaymentMethod(String paymentMethodId) {
    try {
      for (var pm in paymentMethods) {
        pm['isDefault'] = pm['id'] == paymentMethodId;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get card brand icon name
  static String getCardBrandIcon(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return 'visa';
      case 'mastercard':
        return 'mastercard';
      case 'amex':
      case 'american express':
        return 'amex';
      case 'discover':
        return 'discover';
      default:
        return 'credit_card';
    }
  }

  /// Get card brand color
  static int getCardBrandColor(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return 0xFF1A1F71; // Visa blue
      case 'mastercard':
        return 0xFFEB001B; // Mastercard red
      case 'amex':
      case 'american express':
        return 0xFF006FCF; // Amex blue
      case 'discover':
        return 0xFFFF6000; // Discover orange
      default:
        return 0xFF757575; // Grey
    }
  }

  /// Check if card is expired
  static bool isExpired(int expiryMonth, int expiryYear) {
    final now = DateTime.now();
    final expiryDate = DateTime(expiryYear, expiryMonth);
    return expiryDate.isBefore(now);
  }

  /// Format expiry date
  static String formatExpiryDate(int month, int year) {
    return '${month.toString().padLeft(2, '0')}/${year.toString().substring(2)}';
  }
}
