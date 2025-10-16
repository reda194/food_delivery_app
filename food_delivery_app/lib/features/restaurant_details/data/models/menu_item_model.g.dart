// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItemModel _$MenuItemModelFromJson(Map<String, dynamic> json) =>
    MenuItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      isVegan: json['isVegan'] as bool? ?? false,
      isSpicy: json['isSpicy'] as bool? ?? false,
      discount: (json['discount'] as num?)?.toDouble(),
      preparationTime: json['preparationTime'] as int? ?? 15,
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      calories: json['calories'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
    );

Map<String, dynamic> _$MenuItemModelToJson(MenuItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'isAvailable': instance.isAvailable,
      'isVegetarian': instance.isVegetarian,
      'isVegan': instance.isVegan,
      'isSpicy': instance.isSpicy,
      'discount': instance.discount,
      'preparationTime': instance.preparationTime,
      'allergens': instance.allergens,
      'calories': instance.calories,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
    };
