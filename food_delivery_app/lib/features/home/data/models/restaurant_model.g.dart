// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantModel _$RestaurantModelFromJson(Map<String, dynamic> json) =>
    RestaurantModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Restaurant',
      imageUrl: json['image_url'] as String? ?? 'assets/images/burer.png',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: json['review_count'] as int? ?? 0,
      deliveryTime: json['delivery_time'] as int? ?? 30,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 2.99,
      cuisines: (json['cuisines'] as List<dynamic>?)?.map((e) => e as String).toList() ?? ['Food'],
      isFeatured: json['is_featured'] as bool? ?? false,
      isOpen: json['is_open'] as bool? ?? true,
      distance: (json['distance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RestaurantModelToJson(RestaurantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'rating': instance.rating,
      'review_count': instance.reviewCount,
      'delivery_time': instance.deliveryTime,
      'delivery_fee': instance.deliveryFee,
      'cuisines': instance.cuisines,
      'is_featured': instance.isFeatured,
      'is_open': instance.isOpen,
      'distance': instance.distance,
    };
