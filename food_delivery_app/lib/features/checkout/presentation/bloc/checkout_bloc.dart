import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_addresses_usecase.dart';
import '../../domain/usecases/get_payment_methods_usecase.dart';
import '../../domain/usecases/place_order_usecase.dart';
import '../../../cart/domain/usecases/get_cart_usecase.dart';
import '../../../cart/domain/usecases/clear_cart_usecase.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

/// Checkout Bloc - Manages checkout state
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final GetAddressesUseCase getAddressesUseCase;
  final GetPaymentMethodsUseCase getPaymentMethodsUseCase;
  final PlaceOrderUseCase placeOrderUseCase;
  final GetCartUseCase getCartUseCase;
  final ClearCartUseCase clearCartUseCase;

  CheckoutBloc({
    required this.getAddressesUseCase,
    required this.getPaymentMethodsUseCase,
    required this.placeOrderUseCase,
    required this.getCartUseCase,
    required this.clearCartUseCase,
  }) : super(const CheckoutInitial()) {
    on<LoadCheckoutDataEvent>(_onLoadCheckoutData);
    on<SelectAddressEvent>(_onSelectAddress);
    on<SelectPaymentMethodEvent>(_onSelectPaymentMethod);
    on<AddSpecialInstructionsEvent>(_onAddSpecialInstructions);
    on<PlaceOrderEvent>(_onPlaceOrder);
  }

  Future<void> _onLoadCheckoutData(
    LoadCheckoutDataEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutLoading());

    // Load cart
    final cartResult = await getCartUseCase();

    await cartResult.fold(
      (failure) async {
        emit(CheckoutError(failure.message));
      },
      (cart) async {
        if (cart.isEmpty) {
          emit(const CheckoutError('Cart is empty'));
          return;
        }

        // Load addresses and payment methods in parallel
        final addressesResult = await getAddressesUseCase();
        final paymentMethodsResult = await getPaymentMethodsUseCase();

        addressesResult.fold(
          (failure) {
            emit(CheckoutError(failure.message));
          },
          (addresses) {
            paymentMethodsResult.fold(
              (failure) {
                emit(CheckoutError(failure.message));
              },
              (paymentMethods) {
                // Select default address and payment method if available
                final defaultAddress = addresses.isEmpty
                    ? null
                    : addresses.firstWhere(
                        (addr) => addr.isDefault,
                        orElse: () => addresses.first,
                      );
                final defaultPayment = paymentMethods.isEmpty
                    ? null
                    : paymentMethods.firstWhere(
                        (pm) => pm.isDefault,
                        orElse: () => paymentMethods.first,
                      );

                // Calculate tax (10% of subtotal)
                final tax = cart.total * 0.10;

                emit(CheckoutLoaded(
                  cart: cart,
                  addresses: addresses,
                  paymentMethods: paymentMethods,
                  selectedAddress: defaultAddress,
                  selectedPaymentMethod: defaultPayment,
                  tax: tax,
                ));
              },
            );
          },
        );
      },
    );
  }

  Future<void> _onSelectAddress(
    SelectAddressEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    if (state is CheckoutLoaded) {
      final currentState = state as CheckoutLoaded;
      emit(currentState.copyWith(selectedAddress: event.address));
    }
  }

  Future<void> _onSelectPaymentMethod(
    SelectPaymentMethodEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    if (state is CheckoutLoaded) {
      final currentState = state as CheckoutLoaded;
      emit(currentState.copyWith(selectedPaymentMethod: event.paymentMethod));
    }
  }

  Future<void> _onAddSpecialInstructions(
    AddSpecialInstructionsEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    if (state is CheckoutLoaded) {
      final currentState = state as CheckoutLoaded;
      emit(currentState.copyWith(specialInstructions: event.instructions));
    }
  }

  Future<void> _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    if (state is! CheckoutLoaded) return;

    final currentState = state as CheckoutLoaded;

    // Validation
    if (currentState.selectedAddress == null) {
      emit(const OrderPlacementFailed('Please select a delivery address'));
      // Restore state
      emit(currentState);
      return;
    }

    if (currentState.selectedPaymentMethod == null) {
      emit(const OrderPlacementFailed('Please select a payment method'));
      // Restore state
      emit(currentState);
      return;
    }

    emit(const PlacingOrder());

    // Convert cart items to map format for API
    final items = currentState.cart.items.map((item) {
      return {
        'menuItemId': item.menuItemId,
        'quantity': item.quantity,
        'price': item.price,
        'selectedAddons': item.selectedAddons,
        'specialInstructions': item.specialInstructions,
      };
    }).toList();

    final result = await placeOrderUseCase(
      restaurantId: currentState.cart.restaurantId ?? '',
      items: items,
      addressId: currentState.selectedAddress!.id,
      paymentMethodId: currentState.selectedPaymentMethod!.id,
      promoCode: currentState.cart.promoCode,
      specialInstructions: currentState.specialInstructions,
    );

    result.fold(
      (failure) {
        emit(OrderPlacementFailed(failure.message));
        // Restore state
        emit(currentState);
      },
      (order) async {
        // Clear cart after successful order
        await clearCartUseCase();
        emit(OrderPlaced(order));
      },
    );
  }
}
