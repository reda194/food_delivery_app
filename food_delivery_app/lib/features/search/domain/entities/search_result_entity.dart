import '../../../restaurant_details/domain/entities/menu_item_entity.dart';

/// Search Result Entity
class SearchResultEntity {
  final List<MenuItemEntity> items;
  final bool hasMore;
  final int totalCount;

  const SearchResultEntity({
    required this.items,
    required this.hasMore,
    required this.totalCount,
  });

  SearchResultEntity copyWith({
    List<MenuItemEntity>? items,
    bool? hasMore,
    int? totalCount,
  }) {
    return SearchResultEntity(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
