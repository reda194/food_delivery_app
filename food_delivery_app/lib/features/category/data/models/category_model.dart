import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category_entity.dart';

part 'category_model.g.dart';

/// Category Model - Data layer
/// Handles serialization/deserialization from JSON (Supabase)
@JsonSerializable()
class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.description,
    super.imageUrl,
    required super.itemCount,
    super.isActive,
    super.sortOrder,
    required super.createdAt,
    super.updatedAt,
  });

  /// Create from JSON (from Supabase)
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  /// Convert to JSON (for Supabase)
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  /// Create from Entity
  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
      itemCount: entity.itemCount,
      isActive: entity.isActive,
      sortOrder: entity.sortOrder,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert to Entity
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      itemCount: itemCount,
      isActive: isActive,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? itemCount,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      itemCount: itemCount ?? this.itemCount,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
