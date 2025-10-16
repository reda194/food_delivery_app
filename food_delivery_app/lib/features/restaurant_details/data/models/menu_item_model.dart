import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/menu_item_entity.dart';

part 'menu_item_model.g.dart';

/// Menu Item Model - Data transfer object with JSON serialization
@JsonSerializable()
class MenuItemModel extends MenuItemEntity {
  const MenuItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.categoryId,
    required super.categoryName,
    super.isAvailable,
    super.isVegetarian,
    super.isVegan,
    super.isSpicy,
    super.discount,
    super.preparationTime,
    super.allergens,
    super.calories,
    super.rating,
    super.reviewCount,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$MenuItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemModelToJson(this);

  factory MenuItemModel.fromEntity(MenuItemEntity entity) {
    return MenuItemModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      imageUrl: entity.imageUrl,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      isAvailable: entity.isAvailable,
      isVegetarian: entity.isVegetarian,
      isVegan: entity.isVegan,
      isSpicy: entity.isSpicy,
      discount: entity.discount,
      preparationTime: entity.preparationTime,
      allergens: entity.allergens,
      calories: entity.calories,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
    );
  }
}
