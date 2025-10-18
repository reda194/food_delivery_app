import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../home/data/models/restaurant_model.dart';
import '../../domain/entities/restaurant_filter.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> getCategoryById(String categoryId);
  Future<List<RestaurantModel>> getRestaurantsByCategory({
    required String categoryId,
    RestaurantFilter? filter,
    int limit = 20,
    int offset = 0,
  });
  Future<List<RestaurantModel>> searchRestaurantsInCategory({
    required String categoryId,
    required String query,
    RestaurantFilter? filter,
  });
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final SupabaseService supabaseService;

  CategoryRemoteDataSourceImpl({required this.supabaseService});

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await supabaseService.client
          .from('categories')
          .select()
          .order('name', ascending: true);

      return (response as List)
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String categoryId) async {
    try {
      final response = await supabaseService.client
          .from('categories')
          .select()
          .eq('id', categoryId)
          .single();

      return CategoryModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RestaurantModel>> getRestaurantsByCategory({
    required String categoryId,
    RestaurantFilter? filter,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // Start with base query
      dynamic query = supabaseService.client
          .from('restaurants')
          .select()
          .eq('category_id', categoryId);

      // Apply filters
      if (filter != null) {
        if (filter.minRating != null) {
          query = query.gte('rating', filter.minRating);
        }

        if (filter.maxDistance != null) {
          query = query.lte('distance', filter.maxDistance);
        }

        if (filter.maxDeliveryTime != null) {
          query = query.lte('delivery_time', filter.maxDeliveryTime);
        }

        if (filter.freeDeliveryOnly) {
          query = query.eq('delivery_fee', 0);
        }

        if (filter.openNowOnly) {
          query = query.eq('is_open', true);
        }

        if (filter.cuisineTypes != null && filter.cuisineTypes!.isNotEmpty) {
          query = query.contains('cuisine_types', filter.cuisineTypes);
        }

        // Apply sorting
        query = query.order(
          filter.sortOption.sortColumn,
          ascending: filter.sortOption.ascending,
        );
      } else {
        // Default sorting by rating
        query = query.order('rating', ascending: false);
      }

      // Apply pagination
      query = query.range(offset, offset + limit - 1);

      final response = await query;

      return (response as List)
          .map((json) => RestaurantModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RestaurantModel>> searchRestaurantsInCategory({
    required String categoryId,
    required String query,
    RestaurantFilter? filter,
  }) async {
    try {
      // Start with base query
      dynamic dbQuery = supabaseService.client
          .from('restaurants')
          .select()
          .eq('category_id', categoryId)
          .ilike('name', '%$query%');

      // Apply filters if provided
      if (filter != null) {
        if (filter.minRating != null) {
          dbQuery = dbQuery.gte('rating', filter.minRating);
        }

        if (filter.maxDistance != null) {
          dbQuery = dbQuery.lte('distance', filter.maxDistance);
        }

        if (filter.maxDeliveryTime != null) {
          dbQuery = dbQuery.lte('delivery_time', filter.maxDeliveryTime);
        }

        if (filter.freeDeliveryOnly) {
          dbQuery = dbQuery.eq('delivery_fee', 0);
        }

        if (filter.openNowOnly) {
          dbQuery = dbQuery.eq('is_open', true);
        }

        // Apply sorting
        dbQuery = dbQuery.order(
          filter.sortOption.sortColumn,
          ascending: filter.sortOption.ascending,
        );
      } else {
        // Default sorting by rating
        dbQuery = dbQuery.order('rating', ascending: false);
      }

      final response = await dbQuery;

      return (response as List)
          .map((json) => RestaurantModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
