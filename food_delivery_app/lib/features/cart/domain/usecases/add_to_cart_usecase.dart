import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart_item_entity.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

/// Add to Cart Use Case
class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<Either<Failure, CartEntity>> call(CartItemEntity item) async {
    // Validate item
    if (item.quantity <= 0) {
      return const Left(ValidationFailure('Quantity must be greater than 0'));
    }

    if (item.price < 0) {
      return const Left(ValidationFailure('Price cannot be negative'));
    }

    // Get current cart to check restaurant
    final cartResult = await repository.getCart();

    return await cartResult.fold(
      (failure) => Left(failure),
      (cart) async {
        // Check if item is from same restaurant
        if (!cart.canAddItemFromRestaurant(item.restaurantId)) {
          return const Left(ValidationFailure(
            'Cannot add items from different restaurants. Please clear your cart first.',
          ));
        }

        return await repository.addItem(item);
      },
    );
  }
}
