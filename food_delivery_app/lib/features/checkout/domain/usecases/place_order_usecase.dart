import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/order_entity.dart';
import '../repositories/checkout_repository.dart';

/// Place Order Use Case
class PlaceOrderUseCase {
  final CheckoutRepository repository;

  PlaceOrderUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call({
    required String restaurantId,
    required List<dynamic> items,
    required String addressId,
    required String paymentMethodId,
    String? promoCode,
    String? specialInstructions,
  }) async {
    // Validation
    if (restaurantId.isEmpty) {
      return const Left(ValidationFailure('Restaurant ID is required'));
    }

    if (items.isEmpty) {
      return const Left(ValidationFailure('Order must have at least one item'));
    }

    if (addressId.isEmpty) {
      return const Left(ValidationFailure('Delivery address is required'));
    }

    if (paymentMethodId.isEmpty) {
      return const Left(ValidationFailure('Payment method is required'));
    }

    return await repository.placeOrder(
      restaurantId: restaurantId,
      items: items,
      addressId: addressId,
      paymentMethodId: paymentMethodId,
      promoCode: promoCode,
      specialInstructions: specialInstructions,
    );
  }
}
