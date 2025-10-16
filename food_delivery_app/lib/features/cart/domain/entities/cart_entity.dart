import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

/// Cart Entity - Represents the shopping cart
class CartEntity extends Equatable {
  final List<CartItemEntity> items;
  final String? promoCode;
  final double? promoDiscount;

  const CartEntity({
    this.items = const [],
    this.promoCode,
    this.promoDiscount,
  });

  /// Calculate subtotal (sum of all items)
  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Calculate discount amount
  double get discountAmount {
    if (promoDiscount == null || promoDiscount! <= 0) return 0.0;
    return subtotal * (promoDiscount! / 100);
  }

  /// Calculate total after discount
  double get total {
    return subtotal - discountAmount;
  }

  /// Total number of items in cart
  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart is not empty
  bool get isNotEmpty => items.isNotEmpty;

  /// Get restaurant ID (all items must be from same restaurant)
  String? get restaurantId {
    if (items.isEmpty) return null;
    return items.first.restaurantId;
  }

  /// Get restaurant name
  String? get restaurantName {
    if (items.isEmpty) return null;
    return items.first.restaurantName;
  }

  /// Check if can add item from different restaurant
  bool canAddItemFromRestaurant(String restaurantId) {
    if (isEmpty) return true;
    return this.restaurantId == restaurantId;
  }

  CartEntity copyWith({
    List<CartItemEntity>? items,
    String? promoCode,
    double? promoDiscount,
    bool clearPromo = false,
  }) {
    return CartEntity(
      items: items ?? this.items,
      promoCode: clearPromo ? null : (promoCode ?? this.promoCode),
      promoDiscount: clearPromo ? null : (promoDiscount ?? this.promoDiscount),
    );
  }

  @override
  List<Object?> get props => [items, promoCode, promoDiscount];
}
