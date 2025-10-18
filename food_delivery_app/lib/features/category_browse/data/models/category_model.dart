import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.description,
    super.imageUrl,
    super.iconUrl,
    required super.restaurantCount,
    super.isPopular,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      iconUrl: json['icon_url'] as String?,
      restaurantCount: json['restaurant_count'] as int? ?? 0,
      isPopular: json['is_popular'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'icon_url': iconUrl,
      'restaurant_count': restaurantCount,
      'is_popular': isPopular,
    };
  }
}
