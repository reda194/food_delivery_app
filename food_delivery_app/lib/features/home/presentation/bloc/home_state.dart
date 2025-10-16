import 'package:equatable/equatable.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/restaurant_entity.dart';

/// Home States - All possible states of the home screen
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Loading State
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Loaded State - Data successfully loaded
class HomeLoaded extends HomeState {
  final List<RestaurantEntity> featuredRestaurants;
  final List<CategoryEntity> categories;
  final List<RestaurantEntity> displayedRestaurants;
  final String? selectedCategoryId;
  final bool isSearching;
  final String? searchQuery;

  const HomeLoaded({
    required this.featuredRestaurants,
    required this.categories,
    required this.displayedRestaurants,
    this.selectedCategoryId,
    this.isSearching = false,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [
        featuredRestaurants,
        categories,
        displayedRestaurants,
        selectedCategoryId,
        isSearching,
        searchQuery,
      ];

  /// Copy with method for immutable state updates
  HomeLoaded copyWith({
    List<RestaurantEntity>? featuredRestaurants,
    List<CategoryEntity>? categories,
    List<RestaurantEntity>? displayedRestaurants,
    String? selectedCategoryId,
    bool? isSearching,
    String? searchQuery,
  }) {
    return HomeLoaded(
      featuredRestaurants: featuredRestaurants ?? this.featuredRestaurants,
      categories: categories ?? this.categories,
      displayedRestaurants: displayedRestaurants ?? this.displayedRestaurants,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Error State
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Refreshing State - Shows loading indicator during refresh
class HomeRefreshing extends HomeState {
  final HomeLoaded previousState;

  const HomeRefreshing(this.previousState);

  @override
  List<Object?> get props => [previousState];
}
