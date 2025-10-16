import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

/// Update Cart Item Use Case
class UpdateCartItemUseCase {
  final CartRepository repository;

  UpdateCartItemUseCase(this.repository);

  Future<Either<Failure, CartEntity>> call({
    required String itemId,
    required int quantity,
  }) async {
    if (quantity < 0) {
      return const Left(ValidationFailure('Quantity cannot be negative'));
    }

    if (quantity == 0) {
      // Remove item if quantity is 0
      return await repository.removeItem(itemId);
    }

    return await repository.updateItemQuantity(itemId, quantity);
  }
}
