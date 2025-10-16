// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantDetailsModel _$RestaurantDetailsModelFromJson(
        Map<String, dynamic> json) =>
    RestaurantDetailsModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      deliveryTime: json['deliveryTime'] as int,
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      minimumOrder: (json['minimumOrder'] as num).toDouble(),
      cuisines:
          (json['cuisines'] as List<dynamic>).map((e) => e as String).toList(),
      imageUrl: json['imageUrl'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isFeatured: json['isFeatured'] as bool? ?? false,
      isOpen: json['isOpen'] as bool? ?? true,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      openingHours: (json['openingHours'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, OpeningHoursModel.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      menuCategories: (json['menuCategories'] as List<dynamic>?)
              ?.map((e) => MenuCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      popularItems: (json['popularItems'] as List<dynamic>?)
              ?.map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recentReviews: (json['recentReviews'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      acceptsCash: json['acceptsCash'] as bool? ?? true,
      acceptsCards: json['acceptsCards'] as bool? ?? true,
      hasDelivery: json['hasDelivery'] as bool? ?? true,
      hasPickup: json['hasPickup'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
    );

Map<String, dynamic> _$RestaurantDetailsModelToJson(
        RestaurantDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'deliveryTime': instance.deliveryTime,
      'deliveryFee': instance.deliveryFee,
      'minimumOrder': instance.minimumOrder,
      'cuisines': instance.cuisines,
      'imageUrl': instance.imageUrl,
      'images': instance.images,
      'isFeatured': instance.isFeatured,
      'isOpen': instance.isOpen,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'openingHours': instance.openingHours,
      'menuCategories': instance.menuCategories,
      'popularItems': instance.popularItems,
      'recentReviews': instance.recentReviews,
      'acceptsCash': instance.acceptsCash,
      'acceptsCards': instance.acceptsCards,
      'hasDelivery': instance.hasDelivery,
      'hasPickup': instance.hasPickup,
      'tags': instance.tags,
    };

OpeningHoursModel _$OpeningHoursModelFromJson(Map<String, dynamic> json) =>
    OpeningHoursModel(
      isOpen: json['isOpen'] as bool,
      openTime: json['openTime'] as String,
      closeTime: json['closeTime'] as String,
    );

Map<String, dynamic> _$OpeningHoursModelToJson(OpeningHoursModel instance) =>
    <String, dynamic>{
      'isOpen': instance.isOpen,
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
    };

MenuCategoryModel _$MenuCategoryModelFromJson(Map<String, dynamic> json) =>
    MenuCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      itemCount: json['itemCount'] as int,
    );

Map<String, dynamic> _$MenuCategoryModelToJson(MenuCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'itemCount': instance.itemCount,
    };
