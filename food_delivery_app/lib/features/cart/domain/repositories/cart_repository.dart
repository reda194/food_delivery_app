import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart_item_entity.dart';
import '../entities/cart_entity.dart';

/// Cart Repository - Abstract interface for cart operations
abstract class CartRepository {
  /// Get current cart
  Future<Either<Failure, CartEntity>> getCart();

  /// Add item to cart
  Future<Either<Failure, CartEntity>> addItem(CartItemEntity item);

  /// Update item quantity
  Future<Either<Failure, CartEntity>> updateItemQuantity(String itemId, int quantity);

  /// Remove item from cart
  Future<Either<Failure, CartEntity>> removeItem(String itemId);

  /// Clear entire cart
  Future<Either<Failure, void>> clearCart();

  /// Apply promo code
  Future<Either<Failure, CartEntity>> applyPromoCode(String promoCode);

  /// Remove promo code
  Future<Either<Failure, CartEntity>> removePromoCode();

  /// Get cart item count
  Future<Either<Failure, int>> getCartItemCount();

  /// Check and clear expired cart
  Future<Either<Failure, bool>> checkAndClearExpiredCart(Duration expirationDuration);

  /// Check if items are still available
  Future<Either<Failure, Map<String, bool>>> checkItemsAvailability();

  /// Validate cart for cross-restaurant items
  Future<Either<Failure, bool>> validateCartRestaurant(String restaurantId);
}
