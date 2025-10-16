import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category_entity.dart';

part 'category_model.g.dart';

/// Category Model - Data layer representation with JSON serialization
@JsonSerializable()
class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.iconUrl,
    required super.restaurantCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  /// Convert to entity
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      iconUrl: iconUrl,
      restaurantCount: restaurantCount,
    );
  }

  /// Create from entity
  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUrl,
      iconUrl: entity.iconUrl,
      restaurantCount: entity.restaurantCount,
    );
  }
}
