/// Search Filter Entity
class SearchFilterEntity {
  final String? category;
  final String? sortBy;
  final double? minPrice;
  final double? maxPrice;

  const SearchFilterEntity({
    this.category,
    this.sortBy,
    this.minPrice,
    this.maxPrice,
  });

  SearchFilterEntity copyWith({
    String? category,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
  }) {
    return SearchFilterEntity(
      category: category ?? this.category,
      sortBy: sortBy ?? this.sortBy,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchFilterEntity &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          sortBy == other.sortBy &&
          minPrice == other.minPrice &&
          maxPrice == other.maxPrice;

  @override
  int get hashCode =>
      category.hashCode ^
      sortBy.hashCode ^
      minPrice.hashCode ^
      maxPrice.hashCode;
}
