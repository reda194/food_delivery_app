import 'package:equatable/equatable.dart';
import '../../../restaurant_details/domain/entities/menu_item_entity.dart';
import '../../domain/entities/search_filter_entity.dart';

/// Search State Base Class
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Search Initial State
class SearchInitial extends SearchState {}

/// Search Loading State
class SearchLoading extends SearchState {}

/// Search Loaded State
class SearchLoaded extends SearchState {
  final List<MenuItemEntity> items;
  final bool hasMore;
  final int totalCount;
  final String currentQuery;
  final SearchFilterEntity? currentFilters;

  const SearchLoaded({
    required this.items,
    required this.hasMore,
    required this.totalCount,
    required this.currentQuery,
    this.currentFilters,
  });

  @override
  List<Object?> get props => [
        items,
        hasMore,
        totalCount,
        currentQuery,
        currentFilters,
      ];
}

/// Search Error State
class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Recent Searches Loaded State
class RecentSearchesLoaded extends SearchState {
  final List<String> recentSearches;

  const RecentSearchesLoaded(this.recentSearches);

  @override
  List<Object?> get props => [recentSearches];
}

/// Popular Searches Loaded State
class PopularSearchesLoaded extends SearchState {
  final List<String> popularSearches;

  const PopularSearchesLoaded(this.popularSearches);

  @override
  List<Object?> get props => [popularSearches];
}
