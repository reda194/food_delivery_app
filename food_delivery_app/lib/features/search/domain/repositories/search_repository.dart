import '../entities/search_filter_entity.dart';
import '../entities/search_result_entity.dart';

/// Search Repository Interface
abstract class SearchRepository {
  /// Search for food items based on query and filters
  Future<SearchResultEntity> searchItems({
    required String query,
    SearchFilterEntity? filters,
    int page = 1,
    int limit = 20,
  });

  /// Get recent searches for the user
  Future<List<String>> getRecentSearches();

  /// Save a search query to recent searches
  Future<void> saveRecentSearch(String query);

  /// Clear recent searches
  Future<void> clearRecentSearches();

  /// Get popular search suggestions
  Future<List<String>> getPopularSearches();
}
