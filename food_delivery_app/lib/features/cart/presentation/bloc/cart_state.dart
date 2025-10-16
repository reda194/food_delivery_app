import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_entity.dart';

/// Base state class for Cart
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CartInitial extends CartState {
  const CartInitial();
}

/// Loading state
class CartLoading extends CartState {
  const CartLoading();
}

/// Loaded state with cart data
class CartLoaded extends CartState {
  final CartEntity cart;

  const CartLoaded(this.cart);

  @override
  List<Object?> get props => [cart];
}

/// Error state
class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Item added to cart state (for showing success message)
class CartItemAdded extends CartState {
  final CartEntity cart;
  final String itemName;

  const CartItemAdded({
    required this.cart,
    required this.itemName,
  });

  @override
  List<Object?> get props => [cart, itemName];
}

/// Item removed from cart state
class CartItemRemoved extends CartState {
  final CartEntity cart;

  const CartItemRemoved(this.cart);

  @override
  List<Object?> get props => [cart];
}

/// Cart cleared state
class CartCleared extends CartState {
  const CartCleared();
}

/// Promo code applied state
class PromoCodeApplied extends CartState {
  final CartEntity cart;
  final String promoCode;
  final double discount;

  const PromoCodeApplied({
    required this.cart,
    required this.promoCode,
    required this.discount,
  });

  @override
  List<Object?> get props => [cart, promoCode, discount];
}

/// Promo code error state
class PromoCodeError extends CartState {
  final CartEntity cart;
  final String message;

  const PromoCodeError({
    required this.cart,
    required this.message,
  });

  @override
  List<Object?> get props => [cart, message];
}

/// Different restaurant error state
class DifferentRestaurantError extends CartState {
  final CartEntity cart;
  final String currentRestaurant;
  final String newRestaurant;

  const DifferentRestaurantError({
    required this.cart,
    required this.currentRestaurant,
    required this.newRestaurant,
  });

  @override
  List<Object?> get props => [cart, currentRestaurant, newRestaurant];
}
