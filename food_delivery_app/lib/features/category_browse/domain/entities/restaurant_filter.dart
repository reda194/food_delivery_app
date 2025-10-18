import 'package:equatable/equatable.dart';

enum SortOption {
  rating,
  priceAscending,
  priceDescending,
  distance,
  deliveryTime,
  popularity,
}

extension SortOptionExtension on SortOption {
  String get displayName {
    switch (this) {
      case SortOption.rating:
        return 'Highest Rated';
      case SortOption.priceAscending:
        return 'Price: Low to High';
      case SortOption.priceDescending:
        return 'Price: High to Low';
      case SortOption.distance:
        return 'Nearest';
      case SortOption.deliveryTime:
        return 'Fastest Delivery';
      case SortOption.popularity:
        return 'Most Popular';
    }
  }

  String get sortColumn {
    switch (this) {
      case SortOption.rating:
        return 'rating';
      case SortOption.priceAscending:
      case SortOption.priceDescending:
        return 'average_price';
      case SortOption.distance:
        return 'distance';
      case SortOption.deliveryTime:
        return 'delivery_time';
      case SortOption.popularity:
        return 'popularity_score';
    }
  }

  bool get ascending {
    switch (this) {
      case SortOption.priceAscending:
      case SortOption.distance:
      case SortOption.deliveryTime:
        return true;
      case SortOption.rating:
      case SortOption.priceDescending:
      case SortOption.popularity:
        return false;
    }
  }
}

class RestaurantFilter extends Equatable {
  final String? categoryId;
  final SortOption sortOption;
  final double? minRating;
  final double? maxDistance;
  final int? maxDeliveryTime;
  final bool freeDeliveryOnly;
  final bool openNowOnly;
  final List<String>? cuisineTypes;

  const RestaurantFilter({
    this.categoryId,
    this.sortOption = SortOption.rating,
    this.minRating,
    this.maxDistance,
    this.maxDeliveryTime,
    this.freeDeliveryOnly = false,
    this.openNowOnly = false,
    this.cuisineTypes,
  });

  RestaurantFilter copyWith({
    String? categoryId,
    SortOption? sortOption,
    double? minRating,
    double? maxDistance,
    int? maxDeliveryTime,
    bool? freeDeliveryOnly,
    bool? openNowOnly,
    List<String>? cuisineTypes,
  }) {
    return RestaurantFilter(
      categoryId: categoryId ?? this.categoryId,
      sortOption: sortOption ?? this.sortOption,
      minRating: minRating ?? this.minRating,
      maxDistance: maxDistance ?? this.maxDistance,
      maxDeliveryTime: maxDeliveryTime ?? this.maxDeliveryTime,
      freeDeliveryOnly: freeDeliveryOnly ?? this.freeDeliveryOnly,
      openNowOnly: openNowOnly ?? this.openNowOnly,
      cuisineTypes: cuisineTypes ?? this.cuisineTypes,
    );
  }

  @override
  List<Object?> get props => [
        categoryId,
        sortOption,
        minRating,
        maxDistance,
        maxDeliveryTime,
        freeDeliveryOnly,
        openNowOnly,
        cuisineTypes,
      ];
}
