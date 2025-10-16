import 'package:equatable/equatable.dart';

/// Home Events - All events that can occur in the home feature
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Load Home Data Event - Loads all home screen data
class LoadHomeDataEvent extends HomeEvent {
  const LoadHomeDataEvent();
}

/// Refresh Home Data Event - Refreshes all home screen data
class RefreshHomeDataEvent extends HomeEvent {
  const RefreshHomeDataEvent();
}

/// Select Category Event - Filters restaurants by category
class SelectCategoryEvent extends HomeEvent {
  final String? categoryId; // null means show all

  const SelectCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

/// Search Restaurants Event - Searches restaurants
class SearchRestaurantsEvent extends HomeEvent {
  final String query;

  const SearchRestaurantsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Clear Search Event - Clears search results
class ClearSearchEvent extends HomeEvent {
  const ClearSearchEvent();
}
