import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/restaurant_entity.dart';
import '../entities/category_entity.dart';
import '../entities/restaurant_filter.dart';

abstract class CategoryRepository {
  /// Get all categories
  Future<Either<Failure, List<CategoryEntity>>> getCategories();

  /// Get category details by ID
  Future<Either<Failure, CategoryEntity>> getCategoryById(String categoryId);

  /// Get restaurants by category with filtering and sorting
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurantsByCategory({
    required String categoryId,
    RestaurantFilter? filter,
    int limit = 20,
    int offset = 0,
  });

  /// Search restaurants in category
  Future<Either<Failure, List<RestaurantEntity>>> searchRestaurantsInCategory({
    required String categoryId,
    required String query,
    RestaurantFilter? filter,
  });
}
