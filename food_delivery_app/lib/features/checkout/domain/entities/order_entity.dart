import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';

/// Order Entity - Represents a placed order
class OrderEntity extends Equatable {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final List<CartItemEntity> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double tax;
  final double total;
  final String addressId;
  final String addressText;
  final String paymentMethodId;
  final String paymentMethod;
  final String status; // pending, confirmed, preparing, on_the_way, delivered, cancelled
  final DateTime createdAt;
  final DateTime? estimatedDeliveryTime;
  final String? specialInstructions;
  final String? promoCode;

  const OrderEntity({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.tax,
    required this.total,
    required this.addressId,
    required this.addressText,
    required this.paymentMethodId,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.estimatedDeliveryTime,
    this.specialInstructions,
    this.promoCode,
  });

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        restaurantName,
        items,
        subtotal,
        deliveryFee,
        discount,
        tax,
        total,
        addressId,
        addressText,
        paymentMethodId,
        paymentMethod,
        status,
        createdAt,
        estimatedDeliveryTime,
        specialInstructions,
        promoCode,
      ];
}
