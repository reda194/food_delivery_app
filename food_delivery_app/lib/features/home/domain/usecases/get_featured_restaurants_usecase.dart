import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/restaurant_entity.dart';
import '../repositories/home_repository.dart';

/// Use Case: Get Featured Restaurants
/// Retrieves featured restaurants for the home screen
class GetFeaturedRestaurantsUseCase {
  final HomeRepository repository;

  GetFeaturedRestaurantsUseCase(this.repository);

  Future<Either<Failure, List<RestaurantEntity>>> call() async {
    return await repository.getFeaturedRestaurants();
  }
}
