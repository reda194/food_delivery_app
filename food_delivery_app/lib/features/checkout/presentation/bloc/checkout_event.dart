import 'package:equatable/equatable.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/payment_method_entity.dart';

/// Base event class for Checkout
abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

/// Load checkout data event
class LoadCheckoutDataEvent extends CheckoutEvent {
  const LoadCheckoutDataEvent();
}

/// Select address event
class SelectAddressEvent extends CheckoutEvent {
  final AddressEntity address;

  const SelectAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

/// Select payment method event
class SelectPaymentMethodEvent extends CheckoutEvent {
  final PaymentMethodEntity paymentMethod;

  const SelectPaymentMethodEvent(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

/// Add special instructions event
class AddSpecialInstructionsEvent extends CheckoutEvent {
  final String instructions;

  const AddSpecialInstructionsEvent(this.instructions);

  @override
  List<Object?> get props => [instructions];
}

/// Place order event
class PlaceOrderEvent extends CheckoutEvent {
  const PlaceOrderEvent();
}

/// Add new address event
class AddAddressEvent extends CheckoutEvent {
  final AddressEntity address;

  const AddAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

/// Add new payment method event
class AddPaymentMethodEvent extends CheckoutEvent {
  final PaymentMethodEntity paymentMethod;

  const AddPaymentMethodEvent(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}
