import 'package:equatable/equatable.dart';

/// Menu Item Entity - Domain Layer
/// Represents a food item that can be ordered
class MenuItemEntity extends Equatable {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isAvailable;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isSpicy;
  final double? rating;
  final int? reviewCount;
  final List<String>? tags;
  final int? preparationTime; // in minutes
  final int? calories;

  const MenuItemEntity({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isAvailable = true,
    this.isVegetarian = false,
    this.isVegan = false,
    this.isGlutenFree = false,
    this.isSpicy = false,
    this.rating,
    this.reviewCount,
    this.tags,
    this.preparationTime,
    this.calories,
  });

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        name,
        description,
        price,
        imageUrl,
        category,
        isAvailable,
        isVegetarian,
        isVegan,
        isGlutenFree,
        isSpicy,
        rating,
        reviewCount,
        tags,
        preparationTime,
        calories,
      ];

  MenuItemEntity copyWith({
    String? id,
    String? restaurantId,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    bool? isAvailable,
    bool? isVegetarian,
    bool? isVegan,
    bool? isGlutenFree,
    bool? isSpicy,
    double? rating,
    int? reviewCount,
    List<String>? tags,
    int? preparationTime,
    int? calories,
  }) {
    return MenuItemEntity(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isSpicy: isSpicy ?? this.isSpicy,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      tags: tags ?? this.tags,
      preparationTime: preparationTime ?? this.preparationTime,
      calories: calories ?? this.calories,
    );
  }
}
