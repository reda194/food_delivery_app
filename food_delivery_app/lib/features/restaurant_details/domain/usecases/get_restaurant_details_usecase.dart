import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/restaurant_details_entity.dart';
import '../repositories/restaurant_details_repository.dart';

/// Get Restaurant Details Use Case
class GetRestaurantDetailsUseCase {
  final RestaurantDetailsRepository repository;

  GetRestaurantDetailsUseCase(this.repository);

  Future<Either<Failure, RestaurantDetailsEntity>> call(String restaurantId) async {
    if (restaurantId.isEmpty) {
      return const Left(ValidationFailure('Restaurant ID cannot be empty'));
    }

    return await repository.getRestaurantDetails(restaurantId);
  }
}
