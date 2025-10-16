// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Category',
      imageUrl: json['image_url'] as String? ?? 'assets/images/burer.png',
      iconUrl: json['icon_url'] as String? ?? '🍔',
      restaurantCount: json['restaurant_count'] as int? ?? 0,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'icon_url': instance.iconUrl,
      'restaurant_count': instance.restaurantCount,
    };
