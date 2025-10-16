import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/restaurant_details_entity.dart';
import 'menu_item_model.dart';
import 'review_model.dart';

part 'restaurant_details_model.g.dart';

/// Restaurant Details Model - Data transfer object with JSON serialization
@JsonSerializable()
class RestaurantDetailsModel extends RestaurantDetailsEntity {
  const RestaurantDetailsModel({
    required super.id,
    required super.name,
    required super.description,
    required super.rating,
    required super.reviewCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required super.minimumOrder,
    required super.cuisines,
    required super.imageUrl,
    super.images,
    super.isFeatured,
    super.isOpen,
    required super.phoneNumber,
    required super.address,
    required super.latitude,
    required super.longitude,
    super.openingHours,
    super.menuCategories,
    super.popularItems,
    super.recentReviews,
    super.acceptsCash,
    super.acceptsCards,
    super.hasDelivery,
    super.hasPickup,
    super.tags,
  });

  factory RestaurantDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantDetailsModelToJson(this);
}

/// Opening Hours Model
@JsonSerializable()
class OpeningHoursModel extends OpeningHours {
  const OpeningHoursModel({
    required super.isOpen,
    required super.openTime,
    required super.closeTime,
  });

  factory OpeningHoursModel.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpeningHoursModelToJson(this);
}

/// Menu Category Model
@JsonSerializable()
class MenuCategoryModel extends MenuCategory {
  const MenuCategoryModel({
    required super.id,
    required super.name,
    required super.itemCount,
  });

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$MenuCategoryModelToJson(this);
}
