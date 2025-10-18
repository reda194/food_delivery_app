import 'package:equatable/equatable.dart';
import '../../domain/entities/restaurant_filter.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

/// Load category and restaurants
class LoadCategoryEvent extends CategoryEvent {
  final String categoryId;

  const LoadCategoryEvent({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

/// Apply filter
class ApplyFilterEvent extends CategoryEvent {
  final RestaurantFilter filter;

  const ApplyFilterEvent({required this.filter});

  @override
  List<Object?> get props => [filter];
}

/// Change sort option
class ChangeSortOptionEvent extends CategoryEvent {
  final SortOption sortOption;

  const ChangeSortOptionEvent({required this.sortOption});

  @override
  List<Object?> get props => [sortOption];
}

/// Load more restaurants (pagination)
class LoadMoreRestaurantsEvent extends CategoryEvent {
  const LoadMoreRestaurantsEvent();
}

/// Search restaurants in category
class SearchRestaurantsEvent extends CategoryEvent {
  final String query;

  const SearchRestaurantsEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Clear search
class ClearSearchEvent extends CategoryEvent {
  const ClearSearchEvent();
}

/// Refresh restaurants
class RefreshRestaurantsEvent extends CategoryEvent {
  const RefreshRestaurantsEvent();
}
