import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../entities/address_entity.dart';
import '../entities/payment_method_entity.dart';
import '../entities/order_entity.dart';

/// Checkout Repository - Abstract interface for checkout operations
abstract class CheckoutRepository {
  /// Get user's saved addresses
  Future<Either<Failure, List<AddressEntity>>> getAddresses();

  /// Add new address
  Future<Either<Failure, AddressEntity>> addAddress(AddressEntity address);

  /// Update address
  Future<Either<Failure, AddressEntity>> updateAddress(AddressEntity address);

  /// Delete address
  Future<Either<Failure, void>> deleteAddress(String addressId);

  /// Set default address
  Future<Either<Failure, void>> setDefaultAddress(String addressId);

  /// Get payment methods
  Future<Either<Failure, List<PaymentMethodEntity>>> getPaymentMethods();

  /// Add payment method
  Future<Either<Failure, PaymentMethodEntity>> addPaymentMethod(
    PaymentMethodEntity paymentMethod,
  );

  /// Delete payment method
  Future<Either<Failure, void>> deletePaymentMethod(String paymentMethodId);

  /// Calculate delivery fee
  Future<Either<Failure, double>> calculateDeliveryFee({
    required String restaurantId,
    required String addressId,
  });

  /// Place order
  Future<Either<Failure, OrderEntity>> placeOrder({
    required String restaurantId,
    required List<CartItemEntity> items,
    required String addressId,
    required String paymentMethodId,
    String? promoCode,
    String? specialInstructions,
  });

  /// Validate address with geocoding
  Future<Either<Failure, bool>> validateAddressLocation(
    String address,
    double latitude,
    double longitude,
  );

  /// Create payment intent
  Future<Either<Failure, String>> createPaymentIntent({
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  });

  /// Confirm payment
  Future<Either<Failure, bool>> confirmPayment({
    required String paymentIntentId,
    required String paymentMethodId,
  });

  /// Generate receipt
  Future<Either<Failure, String>> generateReceipt(String orderId);
}
