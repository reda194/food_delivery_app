import 'package:hive/hive.dart';
import '../../domain/entities/cart_item_entity.dart';

part 'cart_item_model.g.dart';

/// Cart Item Model - Hive model for local storage
@HiveType(typeId: 0)
class CartItemModel extends CartItemEntity {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String menuItemId;

  @override
  @HiveField(2)
  final String menuItemName;

  @override
  @HiveField(3)
  final String menuItemImage;

  @override
  @HiveField(4)
  final double price;

  @override
  @HiveField(5)
  final int quantity;

  @override
  @HiveField(6)
  final String restaurantId;

  @override
  @HiveField(7)
  final String restaurantName;

  @override
  @HiveField(8)
  final List<String> selectedAddons;

  @override
  @HiveField(9)
  final String? specialInstructions;

  @override
  @HiveField(10)
  final DateTime addedAt;

  const CartItemModel({
    required this.id,
    required this.menuItemId,
    required this.menuItemName,
    required this.menuItemImage,
    required this.price,
    required this.quantity,
    required this.restaurantId,
    required this.restaurantName,
    this.selectedAddons = const [],
    this.specialInstructions,
    required this.addedAt,
  }) : super(
          id: id,
          menuItemId: menuItemId,
          menuItemName: menuItemName,
          menuItemImage: menuItemImage,
          price: price,
          quantity: quantity,
          restaurantId: restaurantId,
          restaurantName: restaurantName,
          selectedAddons: selectedAddons,
          specialInstructions: specialInstructions,
          addedAt: addedAt,
        );

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      menuItemId: json['menuItemId'] as String,
      menuItemName: json['menuItemName'] as String,
      menuItemImage: json['menuItemImage'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      restaurantId: json['restaurantId'] as String,
      restaurantName: json['restaurantName'] as String,
      selectedAddons: (json['selectedAddons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      specialInstructions: json['specialInstructions'] as String?,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menuItemId': menuItemId,
      'menuItemName': menuItemName,
      'menuItemImage': menuItemImage,
      'price': price,
      'quantity': quantity,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'selectedAddons': selectedAddons,
      'specialInstructions': specialInstructions,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      id: entity.id,
      menuItemId: entity.menuItemId,
      menuItemName: entity.menuItemName,
      menuItemImage: entity.menuItemImage,
      price: entity.price,
      quantity: entity.quantity,
      restaurantId: entity.restaurantId,
      restaurantName: entity.restaurantName,
      selectedAddons: entity.selectedAddons,
      specialInstructions: entity.specialInstructions,
      addedAt: entity.addedAt,
    );
  }

  @override
  CartItemModel copyWith({
    String? id,
    String? menuItemId,
    String? menuItemName,
    String? menuItemImage,
    double? price,
    int? quantity,
    String? restaurantId,
    String? restaurantName,
    List<String>? selectedAddons,
    String? specialInstructions,
    DateTime? addedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      menuItemId: menuItemId ?? this.menuItemId,
      menuItemName: menuItemName ?? this.menuItemName,
      menuItemImage: menuItemImage ?? this.menuItemImage,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      selectedAddons: selectedAddons ?? this.selectedAddons,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
