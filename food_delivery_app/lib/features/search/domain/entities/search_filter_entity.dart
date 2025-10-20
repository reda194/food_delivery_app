import 'package:equatable/equatable.dart';

/// Search Filter Entity
class SearchFilterEntity extends Equatable {
  final String? category;
  final String? sortBy; // relevance, price_asc, price_desc, rating, distance, popularity
  final double? minPrice;
  final double? maxPrice;
  final double? minRating; // 0.0 to 5.0
  final double? maxDistance; // in kilometers
  final List<String>? cuisineTypes;
  final List<String>? dietary; // vegetarian, vegan, gluten-free, etc.
  final bool? freeDelivery;
  final bool? openNow;
  final int? minDeliveryTime; // in minutes
  final int? maxDeliveryTime;
  final List<String>? tags; // fast-food, healthy, trending, etc.

  const SearchFilterEntity({
    this.category,
    this.sortBy,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.maxDistance,
    this.cuisineTypes,
    this.dietary,
    this.freeDelivery,
    this.openNow,
    this.minDeliveryTime,
    this.maxDeliveryTime,
    this.tags,
  });

  /// Check if any filters are applied
  bool get hasActiveFilters {
    return category != null ||
        sortBy != null ||
        minPrice != null ||
        maxPrice != null ||
        minRating != null ||
        maxDistance != null ||
        (cuisineTypes != null && cuisineTypes!.isNotEmpty) ||
        (dietary != null && dietary!.isNotEmpty) ||
        freeDelivery != null ||
        openNow != null ||
        minDeliveryTime != null ||
        maxDeliveryTime != null ||
        (tags != null && tags!.isNotEmpty);
  }

  /// Clear all filters
  SearchFilterEntity clearAll() {
    return const SearchFilterEntity();
  }

  SearchFilterEntity copyWith({
    String? category,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    double? maxDistance,
    List<String>? cuisineTypes,
    List<String>? dietary,
    bool? freeDelivery,
    bool? openNow,
    int? minDeliveryTime,
    int? maxDeliveryTime,
    List<String>? tags,
    bool clearFilters = false,
  }) {
    if (clearFilters) return const SearchFilterEntity();

    return SearchFilterEntity(
      category: category ?? this.category,
      sortBy: sortBy ?? this.sortBy,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      maxDistance: maxDistance ?? this.maxDistance,
      cuisineTypes: cuisineTypes ?? this.cuisineTypes,
      dietary: dietary ?? this.dietary,
      freeDelivery: freeDelivery ?? this.freeDelivery,
      openNow: openNow ?? this.openNow,
      minDeliveryTime: minDeliveryTime ?? this.minDeliveryTime,
      maxDeliveryTime: maxDeliveryTime ?? this.maxDeliveryTime,
      tags: tags ?? this.tags,
    );
  }

  /// Convert to query parameters
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};

    if (category != null) params['category'] = category;
    if (sortBy != null) params['sort_by'] = sortBy;
    if (minPrice != null) params['min_price'] = minPrice;
    if (maxPrice != null) params['max_price'] = maxPrice;
    if (minRating != null) params['min_rating'] = minRating;
    if (maxDistance != null) params['max_distance'] = maxDistance;
    if (cuisineTypes != null && cuisineTypes!.isNotEmpty) {
      params['cuisine_types'] = cuisineTypes!.join(',');
    }
    if (dietary != null && dietary!.isNotEmpty) {
      params['dietary'] = dietary!.join(',');
    }
    if (freeDelivery != null) params['free_delivery'] = freeDelivery;
    if (openNow != null) params['open_now'] = openNow;
    if (minDeliveryTime != null) params['min_delivery_time'] = minDeliveryTime;
    if (maxDeliveryTime != null) params['max_delivery_time'] = maxDeliveryTime;
    if (tags != null && tags!.isNotEmpty) {
      params['tags'] = tags!.join(',');
    }

    return params;
  }

  @override
  List<Object?> get props => [
        category,
        sortBy,
        minPrice,
        maxPrice,
        minRating,
        maxDistance,
        cuisineTypes,
        dietary,
        freeDelivery,
        openNow,
        minDeliveryTime,
        maxDeliveryTime,
        tags,
      ];
}
