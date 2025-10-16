import 'package:equatable/equatable.dart';

/// Cart Item Entity - Represents an item in the shopping cart
class CartItemEntity extends Equatable {
  final String id;
  final String menuItemId;
  final String menuItemName;
  final String menuItemImage;
  final double price;
  final int quantity;
  final String restaurantId;
  final String restaurantName;
  final List<String> selectedAddons;
  final String? specialInstructions;
  final DateTime addedAt;

  const CartItemEntity({
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
  });

  double get totalPrice => price * quantity;

  CartItemEntity copyWith({
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
    return CartItemEntity(
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

  @override
  List<Object?> get props => [
        id,
        menuItemId,
        menuItemName,
        menuItemImage,
        price,
        quantity,
        restaurantId,
        restaurantName,
        selectedAddons,
        specialInstructions,
        addedAt,
      ];
}
