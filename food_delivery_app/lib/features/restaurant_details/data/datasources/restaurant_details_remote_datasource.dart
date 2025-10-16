import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/restaurant_details_model.dart';
import '../models/menu_item_model.dart';
import '../models/review_model.dart';

/// Restaurant Details Remote Data Source - Abstract interface
abstract class RestaurantDetailsRemoteDataSource {
  Future<RestaurantDetailsModel> getRestaurantDetails(String restaurantId);
  Future<List<MenuItemModel>> getMenuItemsByCategory(String restaurantId, String categoryId);
  Future<List<MenuItemModel>> getAllMenuItems(String restaurantId);
  Future<List<ReviewModel>> getReviews(String restaurantId, {int page = 1, int limit = 10});
  Future<ReviewModel> submitReview({
    required String restaurantId,
    required double rating,
    required String comment,
    List<String>? imageUrls,
  });
  Future<void> markReviewHelpful(String reviewId);
}

/// Restaurant Details Remote Data Source Implementation
class RestaurantDetailsRemoteDataSourceImpl implements RestaurantDetailsRemoteDataSource {
  final ApiClient apiClient;

  RestaurantDetailsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<RestaurantDetailsModel> getRestaurantDetails(String restaurantId) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.restaurants}/$restaurantId',
      );

      if (response.statusCode == 200) {
        return RestaurantDetailsModel.fromJson(response.data['restaurant']);
      }

      throw Exception('Failed to load restaurant details');
    } catch (e) {
      throw Exception('Error fetching restaurant details: $e');
    }
  }

  @override
  Future<List<MenuItemModel>> getMenuItemsByCategory(
    String restaurantId,
    String categoryId,
  ) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.restaurants}/$restaurantId/menu',
        queryParameters: {'categoryId': categoryId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['items'] ?? [];
        return data.map((json) => MenuItemModel.fromJson(json)).toList();
      }

      throw Exception('Failed to load menu items');
    } catch (e) {
      throw Exception('Error fetching menu items: $e');
    }
  }

  @override
  Future<List<MenuItemModel>> getAllMenuItems(String restaurantId) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.restaurants}/$restaurantId/menu',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['items'] ?? [];
        return data.map((json) => MenuItemModel.fromJson(json)).toList();
      }

      throw Exception('Failed to load menu items');
    } catch (e) {
      throw Exception('Error fetching menu items: $e');
    }
  }

  @override
  Future<List<ReviewModel>> getReviews(
    String restaurantId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.restaurants}/$restaurantId/reviews',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['reviews'] ?? [];
        return data.map((json) => ReviewModel.fromJson(json)).toList();
      }

      throw Exception('Failed to load reviews');
    } catch (e) {
      throw Exception('Error fetching reviews: $e');
    }
  }

  @override
  Future<ReviewModel> submitReview({
    required String restaurantId,
    required double rating,
    required String comment,
    List<String>? imageUrls,
  }) async {
    try {
      final response = await apiClient.post(
        '${ApiConstants.restaurants}/$restaurantId/reviews',
        data: {
          'rating': rating,
          'comment': comment,
          if (imageUrls != null && imageUrls.isNotEmpty) 'images': imageUrls,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ReviewModel.fromJson(response.data['review']);
      }

      throw Exception('Failed to submit review');
    } catch (e) {
      throw Exception('Error submitting review: $e');
    }
  }

  @override
  Future<void> markReviewHelpful(String reviewId) async {
    try {
      final response = await apiClient.post(
        '${ApiConstants.reviews}/$reviewId/helpful',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to mark review as helpful');
      }
    } catch (e) {
      throw Exception('Error marking review as helpful: $e');
    }
  }
}
