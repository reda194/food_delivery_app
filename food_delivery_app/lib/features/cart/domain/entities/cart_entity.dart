import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

/// Cart Entity - Represents the shopping cart
class CartEntity extends Equatable {
  final List<CartItemEntity> items;
  final String? promoCode;
  final double? promoDiscount;
  final DateTime? lastUpdated;
  final DateTime? expiresAt;

  const CartEntity({
    this.items = const [],
    this.promoCode,
    this.promoDiscount,
    this.lastUpdated,
    this.expiresAt,
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

  /// Check if cart has expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if cart is about to expire (within 1 hour)
  bool get isExpiringSoon {
    if (expiresAt == null) return false;
    final difference = expiresAt!.difference(DateTime.now());
    return difference.inMinutes <= 60 && difference.inMinutes > 0;
  }

  /// Get time until expiration
  Duration? get timeUntilExpiration {
    if (expiresAt == null) return null;
    return expiresAt!.difference(DateTime.now());
  }

  CartEntity copyWith({
    List<CartItemEntity>? items,
    String? promoCode,
    double? promoDiscount,
    DateTime? lastUpdated,
    DateTime? expiresAt,
    bool clearPromo = false,
    bool updateTimestamp = false,
  }) {
    final now = DateTime.now();
    return CartEntity(
      items: items ?? this.items,
      promoCode: clearPromo ? null : (promoCode ?? this.promoCode),
      promoDiscount: clearPromo ? null : (promoDiscount ?? this.promoDiscount),
      lastUpdated: updateTimestamp ? now : (lastUpdated ?? this.lastUpdated),
      expiresAt: updateTimestamp
          ? now.add(const Duration(hours: 24))
          : (expiresAt ?? this.expiresAt),
    );
  }

  @override
  List<Object?> get props => [items, promoCode, promoDiscount, lastUpdated, expiresAt];
}
