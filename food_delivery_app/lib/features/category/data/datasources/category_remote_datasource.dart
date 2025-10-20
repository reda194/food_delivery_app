import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/category_model.dart';

/// Category Remote Data Source
/// Handles all API calls related to categories using Supabase
abstract class CategoryRemoteDataSource {
  /// Get all categories
  Future<List<CategoryModel>> getCategories();

  /// Get category by ID
  Future<CategoryModel> getCategoryById(String categoryId);

  /// Get active categories only
  Future<List<CategoryModel>> getActiveCategories();

  /// Search categories by name
  Future<List<CategoryModel>> searchCategories(String query);

  /// Get items in a category
  Future<List<Map<String, dynamic>>> getCategoryItems(String categoryId);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final SupabaseService _supabaseService = SupabaseService.instance;
  final LoggerService _logger = LoggerService.instance;

  static const String _categoriesTable = 'categories';
  static const String _menuItemsTable = 'menu_items';

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      _logger.info('Fetching all categories from Supabase...');

      final response = await _supabaseService.client
          .from(_categoriesTable)
          .select()
          .order('sort_order', ascending: true)
          .order('name', ascending: true);

      _logger.info('Fetched ${response.length} categories');

      return (response as List)
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch categories: $e', stackTrace);
      throw ServerException('Failed to fetch categories: ${e.toString()}');
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String categoryId) async {
    try {
      _logger.info('Fetching category by ID: $categoryId');

      final response = await _supabaseService.client
          .from(_categoriesTable)
          .select()
          .eq('id', categoryId)
          .single();

      _logger.info('Successfully fetched category: $categoryId');

      return CategoryModel.fromJson(response as Map<String, dynamic>);
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch category $categoryId: $e', stackTrace);
      throw ServerException('Failed to fetch category: ${e.toString()}');
    }
  }

  @override
  Future<List<CategoryModel>> getActiveCategories() async {
    try {
      _logger.info('Fetching active categories from Supabase...');

      final response = await _supabaseService.client
          .from(_categoriesTable)
          .select()
          .eq('is_active', true)
          .order('sort_order', ascending: true)
          .order('name', ascending: true);

      _logger.info('Fetched ${response.length} active categories');

      return (response as List)
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch active categories: $e', stackTrace);
      throw ServerException(
          'Failed to fetch active categories: ${e.toString()}');
    }
  }

  @override
  Future<List<CategoryModel>> searchCategories(String query) async {
    try {
      _logger.info('Searching categories with query: $query');

      final response = await _supabaseService.client
          .from(_categoriesTable)
          .select()
          .ilike('name', '%$query%')
          .order('name', ascending: true);

      _logger.info('Found ${response.length} categories matching "$query"');

      return (response as List)
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to search categories: $e', stackTrace);
      throw ServerException('Failed to search categories: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCategoryItems(
      String categoryId) async {
    try {
      _logger.info('Fetching items for category: $categoryId');

      final response = await _supabaseService.client
          .from(_menuItemsTable)
          .select()
          .eq('category_id', categoryId)
          .eq('is_available', true)
          .order('name', ascending: true);

      _logger.info(
          'Fetched ${response.length} items for category $categoryId');

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch category items: $e', stackTrace);
      throw ServerException('Failed to fetch category items: ${e.toString()}');
    }
  }
}
