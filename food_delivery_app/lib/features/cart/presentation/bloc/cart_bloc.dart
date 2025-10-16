import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/update_cart_item_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/apply_promo_code_usecase.dart';
import '../../domain/repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

/// Cart Bloc - Manages cart state
class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;
  final ApplyPromoCodeUseCase applyPromoCodeUseCase;
  final CartRepository repository;

  CartBloc({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartItemUseCase,
    required this.removeFromCartUseCase,
    required this.clearCartUseCase,
    required this.applyPromoCodeUseCase,
    required this.repository,
  }) : super(const CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemQuantityEvent>(_onUpdateCartItemQuantity);
    on<IncrementCartItemEvent>(_onIncrementCartItem);
    on<DecrementCartItemEvent>(_onDecrementCartItem);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
    on<ApplyPromoCodeEvent>(_onApplyPromoCode);
    on<RemovePromoCodeEvent>(_onRemovePromoCode);
  }

  Future<void> _onLoadCart(
    LoadCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());

    final result = await getCartUseCase();

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await addToCartUseCase(event.item);

    result.fold(
      (failure) {
        // Check if it's a different restaurant error
        if (failure.message.contains('different restaurant')) {
          getCartUseCase().then((cartResult) {
            cartResult.fold(
              (error) => emit(CartError(error.message)),
              (cart) => emit(DifferentRestaurantError(
                cart: cart,
                currentRestaurant: cart.restaurantName ?? 'Unknown',
                newRestaurant: event.item.restaurantName,
              )),
            );
          });
        } else {
          emit(CartError(failure.message));
        }
      },
      (cart) => emit(CartItemAdded(
        cart: cart,
        itemName: event.item.menuItemName,
      )),
    );
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await updateCartItemUseCase(
      itemId: event.itemId,
      quantity: event.quantity,
    );

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onIncrementCartItem(
    IncrementCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    // Get current cart to find item's current quantity
    final cartResult = await getCartUseCase();

    await cartResult.fold(
      (failure) async => emit(CartError(failure.message)),
      (cart) async {
        final item = cart.items.firstWhere((item) => item.id == event.itemId);
        final result = await updateCartItemUseCase(
          itemId: event.itemId,
          quantity: item.quantity + 1,
        );

        result.fold(
          (failure) => emit(CartError(failure.message)),
          (updatedCart) => emit(CartLoaded(updatedCart)),
        );
      },
    );
  }

  Future<void> _onDecrementCartItem(
    DecrementCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    // Get current cart to find item's current quantity
    final cartResult = await getCartUseCase();

    await cartResult.fold(
      (failure) async => emit(CartError(failure.message)),
      (cart) async {
        final item = cart.items.firstWhere((item) => item.id == event.itemId);
        final newQuantity = item.quantity - 1;

        if (newQuantity <= 0) {
          // Remove item if quantity becomes 0
          final result = await removeFromCartUseCase(event.itemId);
          result.fold(
            (failure) => emit(CartError(failure.message)),
            (updatedCart) => emit(CartItemRemoved(updatedCart)),
          );
        } else {
          final result = await updateCartItemUseCase(
            itemId: event.itemId,
            quantity: newQuantity,
          );

          result.fold(
            (failure) => emit(CartError(failure.message)),
            (updatedCart) => emit(CartLoaded(updatedCart)),
          );
        }
      },
    );
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await removeFromCartUseCase(event.itemId);

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartItemRemoved(cart)),
    );
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await clearCartUseCase();

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => emit(const CartCleared()),
    );
  }

  Future<void> _onApplyPromoCode(
    ApplyPromoCodeEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await applyPromoCodeUseCase(event.promoCode);

    result.fold(
      (failure) {
        // Get current cart to show it with error
        getCartUseCase().then((cartResult) {
          cartResult.fold(
            (error) => emit(CartError(error.message)),
            (cart) => emit(PromoCodeError(
              cart: cart,
              message: failure.message,
            )),
          );
        });
      },
      (cart) => emit(PromoCodeApplied(
        cart: cart,
        promoCode: event.promoCode,
        discount: cart.promoDiscount ?? 0.0,
      )),
    );
  }

  Future<void> _onRemovePromoCode(
    RemovePromoCodeEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await repository.removePromoCode();

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartLoaded(cart)),
    );
  }
}
