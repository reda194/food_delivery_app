import '../entities/search_filter_entity.dart';
import '../entities/search_result_entity.dart';
import '../repositories/search_repository.dart';

/// Search Items Use Case
class SearchItemsUseCase {
  final SearchRepository repository;

  SearchItemsUseCase(this.repository);

  Future<SearchResultEntity> call({
    required String query,
    SearchFilterEntity? filters,
    int page = 1,
    int limit = 20,
  }) async {
    if (query.trim().isEmpty) {
      throw ArgumentError('Search query cannot be empty');
    }

    return await repository.searchItems(
      query: query.trim(),
      filters: filters,
      page: page,
      limit: limit,
    );
  }
}
