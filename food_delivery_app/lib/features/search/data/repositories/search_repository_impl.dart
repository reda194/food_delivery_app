import '../../domain/entities/search_filter_entity.dart';
import '../../domain/entities/search_result_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_datasource.dart';
import '../datasources/search_local_datasource.dart';

/// Search Repository Implementation
class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SearchLocalDataSource localDataSource;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<SearchResultEntity> searchItems({
    required String query,
    SearchFilterEntity? filters,
    int page = 1,
    int limit = 20,
  }) async {
    final result = await remoteDataSource.searchItems(
      query: query,
      filters: filters,
      page: page,
      limit: limit,
    );

    // Save successful search to recent searches
    if (result.items.isNotEmpty) {
      await localDataSource.saveRecentSearch(query);
    }

    return result;
  }

  @override
  Future<List<String>> getRecentSearches() async {
    return await localDataSource.getRecentSearches();
  }

  @override
  Future<void> saveRecentSearch(String query) async {
    await localDataSource.saveRecentSearch(query);
  }

  @override
  Future<void> clearRecentSearches() async {
    await localDataSource.clearRecentSearches();
  }

  @override
  Future<List<String>> getPopularSearches() async {
    return await remoteDataSource.getPopularSearches();
  }
}
