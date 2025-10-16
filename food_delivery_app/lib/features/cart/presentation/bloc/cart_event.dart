import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item_entity.dart';

/// Base event class for Cart
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Load cart event
class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

/// Add item to cart event
class AddToCartEvent extends CartEvent {
  final CartItemEntity item;

  const AddToCartEvent(this.item);

  @override
  List<Object?> get props => [item];
}

/// Update item quantity event
class UpdateCartItemQuantityEvent extends CartEvent {
  final String itemId;
  final int quantity;

  const UpdateCartItemQuantityEvent({
    required this.itemId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [itemId, quantity];
}

/// Increment item quantity event
class IncrementCartItemEvent extends CartEvent {
  final String itemId;

  const IncrementCartItemEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

/// Decrement item quantity event
class DecrementCartItemEvent extends CartEvent {
  final String itemId;

  const DecrementCartItemEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

/// Remove item from cart event
class RemoveFromCartEvent extends CartEvent {
  final String itemId;

  const RemoveFromCartEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

/// Clear cart event
class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}

/// Apply promo code event
class ApplyPromoCodeEvent extends CartEvent {
  final String promoCode;

  const ApplyPromoCodeEvent(this.promoCode);

  @override
  List<Object?> get props => [promoCode];
}

/// Remove promo code event
class RemovePromoCodeEvent extends CartEvent {
  const RemovePromoCodeEvent();
}
