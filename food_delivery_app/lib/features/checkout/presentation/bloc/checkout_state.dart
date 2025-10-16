import 'package:equatable/equatable.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../../cart/domain/entities/cart_entity.dart';

/// Base state class for Checkout
abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

/// Loading state
class CheckoutLoading extends CheckoutState {
  const CheckoutLoading();
}

/// Loaded state with checkout data
class CheckoutLoaded extends CheckoutState {
  final CartEntity cart;
  final List<AddressEntity> addresses;
  final List<PaymentMethodEntity> paymentMethods;
  final AddressEntity? selectedAddress;
  final PaymentMethodEntity? selectedPaymentMethod;
  final String? specialInstructions;
  final double deliveryFee;
  final double tax;

  const CheckoutLoaded({
    required this.cart,
    required this.addresses,
    required this.paymentMethods,
    this.selectedAddress,
    this.selectedPaymentMethod,
    this.specialInstructions,
    this.deliveryFee = 3.99,
    this.tax = 0.0,
  });

  double get total => cart.total + deliveryFee + tax;

  CheckoutLoaded copyWith({
    CartEntity? cart,
    List<AddressEntity>? addresses,
    List<PaymentMethodEntity>? paymentMethods,
    AddressEntity? selectedAddress,
    PaymentMethodEntity? selectedPaymentMethod,
    String? specialInstructions,
    double? deliveryFee,
    double? tax,
    bool clearInstructions = false,
  }) {
    return CheckoutLoaded(
      cart: cart ?? this.cart,
      addresses: addresses ?? this.addresses,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      specialInstructions: clearInstructions ? null : (specialInstructions ?? this.specialInstructions),
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
    );
  }

  @override
  List<Object?> get props => [
        cart,
        addresses,
        paymentMethods,
        selectedAddress,
        selectedPaymentMethod,
        specialInstructions,
        deliveryFee,
        tax,
      ];
}

/// Error state
class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Placing order state
class PlacingOrder extends CheckoutState {
  const PlacingOrder();
}

/// Order placed successfully state
class OrderPlaced extends CheckoutState {
  final OrderEntity order;

  const OrderPlaced(this.order);

  @override
  List<Object?> get props => [order];
}

/// Order placement failed state
class OrderPlacementFailed extends CheckoutState {
  final String message;

  const OrderPlacementFailed(this.message);

  @override
  List<Object?> get props => [message];
}
