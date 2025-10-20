import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/cart_repository.dart';

/// Validate Cart Restaurant Use Case
/// Checks if an item from a different restaurant can be added to the cart
class ValidateCartRestaurantUseCase {
  final CartRepository repository;

  ValidateCartRestaurantUseCase(this.repository);

  Future<Either<Failure, bool>> call(String restaurantId) async {
    return await repository.validateCartRestaurant(restaurantId);
  }
}
