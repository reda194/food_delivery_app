import '../repositories/search_repository.dart';

/// Get Recent Searches Use Case
class GetRecentSearchesUseCase {
  final SearchRepository repository;

  GetRecentSearchesUseCase(this.repository);

  Future<List<String>> call() async {
    return await repository.getRecentSearches();
  }
}
