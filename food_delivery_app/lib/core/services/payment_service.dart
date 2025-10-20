import 'package:dio/dio.dart';

/// Payment Service - Handles payment gateway integrations
class PaymentService {
  static final PaymentService instance = PaymentService._internal();
  factory PaymentService() => instance;
  PaymentService._internal();

  final Dio _dio = Dio();

  // Stripe keys - Initialize using initializeStripe()
  String _stripePublishableKey = 'pk_test_YOUR_KEY_HERE';
  String _stripeSecretKey = 'sk_test_YOUR_KEY_HERE';

  /// Get the current publishable key (for client-side SDK)
  String get publishableKey => _stripePublishableKey;

  /// Initialize Stripe with your API keys
  /// Get your keys from: https://dashboard.stripe.com/apikeys
  void initializeStripe({
    required String publishableKey,
    required String secretKey,
  }) {
    _stripePublishableKey = publishableKey;
    _stripeSecretKey = secretKey;
  }

  /// Create Payment Intent (Stripe)
  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    String? customerId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: {
          'amount': (amount * 100).toInt(), // Convert to cents
          'currency': currency.toLowerCase(),
          if (customerId != null) 'customer': customerId,
          if (metadata != null) 'metadata': metadata,
          'automatic_payment_methods[enabled]': 'true',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw PaymentException('Failed to create payment intent: $e');
    }
  }

  /// Confirm Payment Intent
  Future<Map<String, dynamic>> confirmPaymentIntent({
    required String paymentIntentId,
    required String paymentMethodId,
  }) async {
    try {
      final response = await _dio.post(
        'https://api.stripe.com/v1/payment_intents/$paymentIntentId/confirm',
        data: {
          'payment_method': paymentMethodId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw PaymentException('Failed to confirm payment: $e');
    }
  }

  /// Create Customer (Stripe)
  Future<Map<String, dynamic>> createCustomer({
    required String email,
    String? name,
    String? phone,
  }) async {
    try {
      final response = await _dio.post(
        'https://api.stripe.com/v1/customers',
        data: {
          'email': email,
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw PaymentException('Failed to create customer: $e');
    }
  }

  /// Attach Payment Method to Customer
  Future<Map<String, dynamic>> attachPaymentMethod({
    required String paymentMethodId,
    required String customerId,
  }) async {
    try {
      final response = await _dio.post(
        'https://api.stripe.com/v1/payment_methods/$paymentMethodId/attach',
        data: {
          'customer': customerId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw PaymentException('Failed to attach payment method: $e');
    }
  }

  /// Create Setup Intent (for saving card without charging)
  Future<Map<String, dynamic>> createSetupIntent({
    required String customerId,
  }) async {
    try {
      final response = await _dio.post(
        'https://api.stripe.com/v1/setup_intents',
        data: {
          'customer': customerId,
          'automatic_payment_methods[enabled]': 'true',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw PaymentException('Failed to create setup intent: $e');
    }
  }

  /// Verify 3D Secure Authentication
  Future<bool> verify3DSecure({
    required String paymentIntentId,
  }) async {
    try {
      final response = await _dio.get(
        'https://api.stripe.com/v1/payment_intents/$paymentIntentId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_stripeSecretKey',
          },
        ),
      );

      final status = response.data['status'] as String?;
      return status == 'succeeded' || status == 'requires_capture';
    } catch (e) {
      throw PaymentException('Failed to verify 3D Secure: $e');
    }
  }

  /// Process Refund
  Future<Map<String, dynamic>> processRefund({
    required String paymentIntentId,
    double? amount, // If null, full refund
    String? reason,
  }) async {
    try {
      final data = <String, dynamic>{
        'payment_intent': paymentIntentId,
        if (amount != null) 'amount': (amount * 100).toInt(),
        if (reason != null) 'reason': reason,
      };

      final response = await _dio.post(
        'https://api.stripe.com/v1/refunds',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw PaymentException('Failed to process refund: $e');
    }
  }

  /// Get Payment Method Details
  Future<Map<String, dynamic>> getPaymentMethod(String paymentMethodId) async {
    try {
      final response = await _dio.get(
        'https://api.stripe.com/v1/payment_methods/$paymentMethodId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_stripeSecretKey',
          },
        ),
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw PaymentException('Failed to get payment method: $e');
    }
  }
}

/// Payment Exception
class PaymentException implements Exception {
  final String message;
  PaymentException(this.message);

  @override
  String toString() => message;
}
