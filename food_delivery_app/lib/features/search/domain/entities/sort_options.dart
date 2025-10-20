/// Sort Options for Search Results
enum SortOption {
  relevance,
  priceAsc,
  priceDesc,
  rating,
  distance,
  popularity,
  deliveryTime,
  newest,
}

extension SortOptionExtension on SortOption {
  String get displayName {
    switch (this) {
      case SortOption.relevance:
        return 'Relevance';
      case SortOption.priceAsc:
        return 'Price: Low to High';
      case SortOption.priceDesc:
        return 'Price: High to Low';
      case SortOption.rating:
        return 'Highest Rated';
      case SortOption.distance:
        return 'Distance';
      case SortOption.popularity:
        return 'Most Popular';
      case SortOption.deliveryTime:
        return 'Fastest Delivery';
      case SortOption.newest:
        return 'Newest';
    }
  }

  String get apiValue {
    switch (this) {
      case SortOption.relevance:
        return 'relevance';
      case SortOption.priceAsc:
        return 'price_asc';
      case SortOption.priceDesc:
        return 'price_desc';
      case SortOption.rating:
        return 'rating';
      case SortOption.distance:
        return 'distance';
      case SortOption.popularity:
        return 'popularity';
      case SortOption.deliveryTime:
        return 'delivery_time';
      case SortOption.newest:
        return 'newest';
    }
  }

  static SortOption fromString(String value) {
    return SortOption.values.firstWhere(
      (option) => option.apiValue == value,
      orElse: () => SortOption.relevance,
    );
  }
}

/// Dietary Restrictions
enum DietaryRestriction {
  vegetarian,
  vegan,
  glutenFree,
  dairyFree,
  nutFree,
  halal,
  kosher,
  keto,
  paleo,
}

extension DietaryRestrictionExtension on DietaryRestriction {
  String get displayName {
    switch (this) {
      case DietaryRestriction.vegetarian:
        return 'Vegetarian';
      case DietaryRestriction.vegan:
        return 'Vegan';
      case DietaryRestriction.glutenFree:
        return 'Gluten-Free';
      case DietaryRestriction.dairyFree:
        return 'Dairy-Free';
      case DietaryRestriction.nutFree:
        return 'Nut-Free';
      case DietaryRestriction.halal:
        return 'Halal';
      case DietaryRestriction.kosher:
        return 'Kosher';
      case DietaryRestriction.keto:
        return 'Keto';
      case DietaryRestriction.paleo:
        return 'Paleo';
    }
  }

  String get apiValue {
    switch (this) {
      case DietaryRestriction.vegetarian:
        return 'vegetarian';
      case DietaryRestriction.vegan:
        return 'vegan';
      case DietaryRestriction.glutenFree:
        return 'gluten_free';
      case DietaryRestriction.dairyFree:
        return 'dairy_free';
      case DietaryRestriction.nutFree:
        return 'nut_free';
      case DietaryRestriction.halal:
        return 'halal';
      case DietaryRestriction.kosher:
        return 'kosher';
      case DietaryRestriction.keto:
        return 'keto';
      case DietaryRestriction.paleo:
        return 'paleo';
    }
  }
}
