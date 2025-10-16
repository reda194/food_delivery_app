import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/restaurant_entity.dart';

part 'restaurant_model.g.dart';

/// Restaurant Model - Data layer representation with JSON serialization
@JsonSerializable()
class RestaurantModel extends RestaurantEntity {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.rating,
    required super.reviewCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required super.cuisines,
    super.isFeatured,
    super.isOpen,
    super.distance,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  /// Convert to entity
  RestaurantEntity toEntity() {
    return RestaurantEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      rating: rating,
      reviewCount: reviewCount,
      deliveryTime: deliveryTime,
      deliveryFee: deliveryFee,
      cuisines: cuisines,
      isFeatured: isFeatured,
      isOpen: isOpen,
      distance: distance,
    );
  }

  /// Create from entity
  factory RestaurantModel.fromEntity(RestaurantEntity entity) {
    return RestaurantModel(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUrl,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      deliveryTime: entity.deliveryTime,
      deliveryFee: entity.deliveryFee,
      cuisines: entity.cuisines,
      isFeatured: entity.isFeatured,
      isOpen: entity.isOpen,
      distance: entity.distance,
    );
  }
}
