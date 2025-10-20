import 'package:equatable/equatable.dart';

/// Category Events
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

/// Load all categories
class LoadCategoriesEvent extends CategoryEvent {
  const LoadCategoriesEvent();
}

/// Load active categories only
class LoadActiveCategoriesEvent extends CategoryEvent {
  const LoadActiveCategoriesEvent();
}

/// Load a specific category by ID
class LoadCategoryByIdEvent extends CategoryEvent {
  final String categoryId;

  const LoadCategoryByIdEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

/// Search categories by query
class SearchCategoriesEvent extends CategoryEvent {
  final String query;

  const SearchCategoriesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Load items in a category
class LoadCategoryItemsEvent extends CategoryEvent {
  final String categoryId;

  const LoadCategoryItemsEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

/// Refresh categories
class RefreshCategoriesEvent extends CategoryEvent {
  const RefreshCategoriesEvent();
}
