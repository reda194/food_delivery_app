import 'package:equatable/equatable.dart';

/// Restaurant Entity - Core business object for restaurants
class RestaurantEntity extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int deliveryTime; // in minutes
  final double deliveryFee;
  final List<String> cuisines;
  final bool isFeatured;
  final bool isOpen;
  final double? distance; // in km

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.cuisines,
    this.isFeatured = false,
    this.isOpen = true,
    this.distance,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        rating,
        reviewCount,
        deliveryTime,
        deliveryFee,
        cuisines,
        isFeatured,
        isOpen,
        distance,
      ];

  @override
  String toString() {
    return 'RestaurantEntity(id: $id, name: $name, rating: $rating)';
  }
}
