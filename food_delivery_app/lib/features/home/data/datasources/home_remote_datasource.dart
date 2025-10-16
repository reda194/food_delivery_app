import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/category_model.dart';
import '../models/restaurant_model.dart';

/// Home Remote Data Source - Handles API calls for home screen data
abstract class HomeRemoteDataSource {
  Future<List<RestaurantModel>> getFeaturedRestaurants();
  Future<List<CategoryModel>> getCategories();
  Future<List<RestaurantModel>> getRestaurantsByCategory(String categoryId);
  Future<List<RestaurantModel>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double? radiusKm,
  });
  Future<List<RestaurantModel>> searchRestaurants(String query);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<RestaurantModel>> getFeaturedRestaurants() async {
    try {
      final response = await apiClient.get(ApiConstants.featuredRestaurants);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['restaurants'] ?? [];
        return data.map((json) => RestaurantModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load featured restaurants');
      }
    } catch (e) {
      throw Exception('Error fetching featured restaurants: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await apiClient.get(ApiConstants.categories);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['categories'] ?? [];
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  @override
  Future<List<RestaurantModel>> getRestaurantsByCategory(
    String categoryId,
  ) async {
    try {
      final path = ApiConstants.replacePathParameter(
        ApiConstants.restaurantsByCategory,
        'category',
        categoryId,
      );
      final response = await apiClient.get(path);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['restaurants'] ?? [];
        return data.map((json) => RestaurantModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load restaurants by category');
      }
    } catch (e) {
      throw Exception('Error fetching restaurants by category: $e');
    }
  }

  @override
  Future<List<RestaurantModel>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double? radiusKm,
  }) async {
    try {
      final queryParams = {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        if (radiusKm != null) 'radius': radiusKm.toString(),
      };

      final response = await apiClient.get(
        ApiConstants.nearbyRestaurants,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['restaurants'] ?? [];
        return data.map((json) => RestaurantModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load nearby restaurants');
      }
    } catch (e) {
      throw Exception('Error fetching nearby restaurants: $e');
    }
  }

  @override
  Future<List<RestaurantModel>> searchRestaurants(String query) async {
    try {
      final response = await apiClient.get(
        ApiConstants.restaurantSearch,
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['restaurants'] ?? [];
        return data.map((json) => RestaurantModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search restaurants');
      }
    } catch (e) {
      throw Exception('Error searching restaurants: $e');
    }
  }
}
