import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/restaurant_details_entity.dart';
import '../entities/menu_item_entity.dart';
import '../entities/review_entity.dart';

/// Restaurant Details Repository - Abstract interface for restaurant details operations
abstract class RestaurantDetailsRepository {
  /// Get detailed information about a restaurant
  Future<Either<Failure, RestaurantDetailsEntity>> getRestaurantDetails(String restaurantId);

  /// Get menu items by category
  Future<Either<Failure, List<MenuItemEntity>>> getMenuItemsByCategory(
    String restaurantId,
    String categoryId,
  );

  /// Get all menu items for a restaurant
  Future<Either<Failure, List<MenuItemEntity>>> getAllMenuItems(String restaurantId);

  /// Get reviews for a restaurant with pagination
  Future<Either<Failure, List<ReviewEntity>>> getReviews(
    String restaurantId, {
    int page = 1,
    int limit = 10,
  });

  /// Submit a review for a restaurant
  Future<Either<Failure, ReviewEntity>> submitReview({
    required String restaurantId,
    required double rating,
    required String comment,
    List<String>? imageUrls,
  });

  /// Mark a review as helpful
  Future<Either<Failure, void>> markReviewHelpful(String reviewId);
}
