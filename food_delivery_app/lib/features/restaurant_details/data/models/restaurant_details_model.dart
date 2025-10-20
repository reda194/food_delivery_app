import 'package:json_annotation/json_annotation.dart';

part 'restaurant_details_model.g.dart';

/// Restaurant Details Model - Data transfer object with JSON serialization
@JsonSerializable()
class RestaurantDetailsModel {
  final String id;
  final String name;
  final String description;
  final double rating;
  final int reviewCount;
  final int deliveryTime;
  final double deliveryFee;
  final double minimumOrder;
  final List<String> cuisines;
  final String imageUrl;
  final List<String>? images;
  final bool? isFeatured;
  final bool? isOpen;
  final String phoneNumber;
  final String address;
  final double latitude;
  final double longitude;
  final Map<String, OpeningHoursModel>? openingHours;
  final List<MenuCategoryModel>? menuCategories;
  final List<Map<String, dynamic>>? popularItems;
  final List<Map<String, dynamic>>? recentReviews;
  final bool? acceptsCash;
  final bool? acceptsCards;
  final bool? hasDelivery;
  final bool? hasPickup;
  final List<String>? tags;

  const RestaurantDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.cuisines,
    required this.imageUrl,
    this.images,
    this.isFeatured,
    this.isOpen,
    required this.phoneNumber,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.openingHours,
    this.menuCategories,
    this.popularItems,
    this.recentReviews,
    this.acceptsCash,
    this.acceptsCards,
    this.hasDelivery,
    this.hasPickup,
    this.tags,
  });

  factory RestaurantDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantDetailsModelToJson(this);
}

/// Opening Hours Model
@JsonSerializable()
class OpeningHoursModel {
  final bool isOpen;
  final String openTime;
  final String closeTime;

  const OpeningHoursModel({
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
  });

  factory OpeningHoursModel.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpeningHoursModelToJson(this);
}

/// Menu Category Model
@JsonSerializable()
class MenuCategoryModel {
  final String id;
  final String name;
  final int itemCount;

  const MenuCategoryModel({
    required this.id,
    required this.name,
    required this.itemCount,
  });

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$MenuCategoryModelToJson(this);
}
