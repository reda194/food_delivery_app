import 'package:equatable/equatable.dart';
import '../../domain/entities/search_filter_entity.dart';

/// Search Event Base Class
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Search Items Event
class SearchItemsEvent extends SearchEvent {
  final String query;
  final SearchFilterEntity? filters;
  final int page;
  final int limit;

  const SearchItemsEvent({
    required this.query,
    this.filters,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [query, filters, page, limit];
}

/// Load Recent Searches Event
class LoadRecentSearchesEvent extends SearchEvent {}

/// Clear Recent Searches Event
class ClearRecentSearchesEvent extends SearchEvent {}

/// Load Popular Searches Event
class LoadPopularSearchesEvent extends SearchEvent {}

/// Apply Search Filter Event
class ApplySearchFilterEvent extends SearchEvent {
  final SearchFilterEntity filters;

  const ApplySearchFilterEvent(this.filters);

  @override
  List<Object?> get props => [filters];
}

/// Clear Search Query Event
class ClearSearchQueryEvent extends SearchEvent {}
