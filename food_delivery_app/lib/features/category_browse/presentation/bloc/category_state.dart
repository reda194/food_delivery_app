import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/restaurant_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/restaurant_filter.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

/// Loading category
class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

/// Category loaded with restaurants
class CategoryLoaded extends CategoryState {
  final CategoryEntity category;
  final List<RestaurantEntity> restaurants;
  final RestaurantFilter currentFilter;
  final bool hasMore;
  final bool isLoadingMore;
  final String? searchQuery;

  const CategoryLoaded({
    required this.category,
    required this.restaurants,
    required this.currentFilter,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [
        category,
        restaurants,
        currentFilter,
        hasMore,
        isLoadingMore,
        searchQuery,
      ];

  CategoryLoaded copyWith({
    CategoryEntity? category,
    List<RestaurantEntity>? restaurants,
    RestaurantFilter? currentFilter,
    bool? hasMore,
    bool? isLoadingMore,
    String? searchQuery,
    bool clearSearch = false,
  }) {
    return CategoryLoaded(
      category: category ?? this.category,
      restaurants: restaurants ?? this.restaurants,
      currentFilter: currentFilter ?? this.currentFilter,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
    );
  }
}

/// Category error
class CategoryError extends CategoryState {
  final String message;

  const CategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
