import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Search Local Data Source
abstract class SearchLocalDataSource {
  Future<List<String>> getRecentSearches();
  Future<void> saveRecentSearch(String query);
  Future<void> clearRecentSearches();
}

/// Search Local Data Source Implementation
class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  static const String _recentSearchesKey = 'recent_searches';
  static const int _maxRecentSearches = 10;

  final SharedPreferences prefs;

  SearchLocalDataSourceImpl(this.prefs);

  @override
  Future<List<String>> getRecentSearches() async {
    try {
      final searchesJson = prefs.getString(_recentSearchesKey);
      if (searchesJson != null) {
        final List<dynamic> searchesList = json.decode(searchesJson);
        return searchesList.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveRecentSearch(String query) async {
    if (query.trim().isEmpty) return;

    try {
      final currentSearches = await getRecentSearches();
      
      // Remove if already exists (to move to top)
      currentSearches.remove(query);
      
      // Add to beginning
      currentSearches.insert(0, query);
      
      // Keep only max number of searches
      if (currentSearches.length > _maxRecentSearches) {
        currentSearches.removeRange(_maxRecentSearches, currentSearches.length);
      }

      final searchesJson = json.encode(currentSearches);
      await prefs.setString(_recentSearchesKey, searchesJson);
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Future<void> clearRecentSearches() async {
    try {
      await prefs.remove(_recentSearchesKey);
    } catch (e) {
      // Handle error silently
    }
  }
}
