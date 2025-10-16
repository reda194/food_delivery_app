import '../../domain/entities/search_filter_entity.dart';
import '../../domain/entities/search_result_entity.dart';
import '../../../../core/network/api_client.dart';
import '../../../restaurant_details/domain/entities/menu_item_entity.dart';

/// Search Remote Data Source
abstract class SearchRemoteDataSource {
  Future<SearchResultEntity> searchItems({
    required String query,
    SearchFilterEntity? filters,
    int page = 1,
    int limit = 20,
  });

  Future<List<String>> getPopularSearches();
}

/// Search Remote Data Source Implementation
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient apiClient;

  SearchRemoteDataSourceImpl(this.apiClient);

  @override
  Future<SearchResultEntity> searchItems({
    required String query,
    SearchFilterEntity? filters,
    int page = 1,
    int limit = 20,
  }) async {
    final Map<String, dynamic> queryParams = {
      'q': query,
      'page': page,
      'limit': limit,
    };

    if (filters?.category != null && filters!.category != 'All') {
      queryParams['category'] = filters.category;
    }

    if (filters?.sortBy != null) {
      final sortBy = filters!.sortBy;
      if (sortBy == 'High Price') {
        queryParams['sort'] = 'price_desc';
      } else if (sortBy == 'Fast Delivery') {
        queryParams['sort'] = 'delivery_time';
      }
    }

    if (filters?.minPrice != null) {
      queryParams['min_price'] = filters!.minPrice;
    }

    if (filters?.maxPrice != null) {
      queryParams['max_price'] = filters!.maxPrice;
    }

    try {
      final response = await apiClient.get(
        '/search',
        queryParameters: queryParams,
      );

      // For now, return mock data since API doesn't exist
      return _getMockSearchResults(query);
    } catch (e) {
      // Fallback to mock data
      return _getMockSearchResults(query);
    }
  }

  @override
  Future<List<String>> getPopularSearches() async {
    try {
      final response = await apiClient.get('/search/popular');
      
      // For now, return mock data
      return ['Burger', 'Pizza', 'Sushi', 'Pasta', 'Salad', 'Tacos', 'Ice Cream'];
    } catch (e) {
      return ['Burger', 'Pizza', 'Sushi', 'Pasta', 'Salad', 'Tacos', 'Ice Cream'];
    }
  }

  SearchResultEntity _getMockSearchResults(String query) {
    final mockItems = List.generate(
      10,
      (index) => MenuItemEntity(
        id: 'item_$index',
        name: '$query ${index + 1}',
        description: 'Delicious $query item',
        price: 12.99 + index,
        imageUrl: 'assets/images/burger.png',
        categoryId: 'food',
        categoryName: query,
        isAvailable: true,
      ),
    );

    return SearchResultEntity(
      items: mockItems,
      hasMore: false,
      totalCount: mockItems.length,
    );
  }
}
