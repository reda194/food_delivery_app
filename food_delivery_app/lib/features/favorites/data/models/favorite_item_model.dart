import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/favorite_item_entity.dart';

part 'favorite_item_model.g.dart';

/// Favorite Item Model - Data transfer object
@JsonSerializable()
class FavoriteItemModel extends FavoriteItemEntity {
  const FavoriteItemModel({
    required super.id,
    required super.menuItemId,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.categoryName,
    required super.addedAt,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteItemModelToJson(this);

  factory FavoriteItemModel.fromEntity(FavoriteItemEntity entity) {
    return FavoriteItemModel(
      id: entity.id,
      menuItemId: entity.menuItemId,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      imageUrl: entity.imageUrl,
      categoryName: entity.categoryName,
      addedAt: entity.addedAt,
    );
  }
}
