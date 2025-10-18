import 'package:equatable/equatable.dart';

/// Favorite Item Entity - Represents a saved food item
class FavoriteItemEntity extends Equatable {
  final String id;
  final String menuItemId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryName;
  final DateTime addedAt;

  const FavoriteItemEntity({
    required this.id,
    required this.menuItemId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryName,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [
        id,
        menuItemId,
        name,
        description,
        price,
        imageUrl,
        categoryName,
        addedAt,
      ];
}
