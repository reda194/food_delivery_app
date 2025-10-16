import 'package:equatable/equatable.dart';

/// Menu Item Entity - Core business object representing a food item
class MenuItemEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final String categoryName;
  final bool isAvailable;
  final bool isVegetarian;
  final bool isVegan;
  final bool isSpicy;
  final double? discount;
  final int preparationTime; // in minutes
  final List<String> allergens;
  final int calories;
  final double rating;
  final int reviewCount;

  const MenuItemEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.categoryName,
    this.isAvailable = true,
    this.isVegetarian = false,
    this.isVegan = false,
    this.isSpicy = false,
    this.discount,
    this.preparationTime = 15,
    this.allergens = const [],
    this.calories = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  double get finalPrice {
    if (discount != null && discount! > 0) {
      return price - (price * discount! / 100);
    }
    return price;
  }

  bool get hasDiscount => discount != null && discount! > 0;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        imageUrl,
        categoryId,
        categoryName,
        isAvailable,
        isVegetarian,
        isVegan,
        isSpicy,
        discount,
        preparationTime,
        allergens,
        calories,
        rating,
        reviewCount,
      ];
}
