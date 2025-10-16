import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category_entity.dart';
import '../entities/restaurant_entity.dart';

/// Home Repository Interface - Defines contract for home data operations
abstract class HomeRepository {
  /// Get featured restaurants for home screen
  Future<Either<Failure, List<RestaurantEntity>>> getFeaturedRestaurants();

  /// Get all categories
  Future<Either<Failure, List<CategoryEntity>>> getCategories();

  /// Get restaurants by category
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurantsByCategory(
    String categoryId,
  );

  /// Get nearby restaurants based on user location
  Future<Either<Failure, List<RestaurantEntity>>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double? radiusKm,
  });

  /// Search restaurants
  Future<Either<Failure, List<RestaurantEntity>>> searchRestaurants(
    String query,
  );
}
