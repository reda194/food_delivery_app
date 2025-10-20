import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';
import '../models/cart_item_model.dart';

/// Cart Repository Implementation
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;
  final ApiClient apiClient;

  CartRepositoryImpl({
    required this.localDataSource,
    required this.apiClient,
  });

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    try {
      final items = await localDataSource.getCartItems();
      final promoCode = await localDataSource.getPromoCode();
      final promoDiscount = await localDataSource.getPromoDiscount();

      return Right(CartEntity(
        items: items,
        promoCode: promoCode,
        promoDiscount: promoDiscount,
      ));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> addItem(CartItemEntity item) async {
    try {
      final model = CartItemModel.fromEntity(item);
      await localDataSource.addCartItem(model);
      return await getCart();
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> updateItemQuantity(
    String itemId,
    int quantity,
  ) async {
    try {
      final items = await localDataSource.getCartItems();
      final item = items.firstWhere((item) => item.id == itemId);
      final updatedItem = item.copyWith(quantity: quantity);
      await localDataSource.updateCartItem(updatedItem);
      return await getCart();
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> removeItem(String itemId) async {
    try {
      await localDataSource.removeCartItem(itemId);
      return await getCart();
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> applyPromoCode(String promoCode) async {
    try {
      // Call API to validate promo code
      final response = await apiClient.post(
        '/coupons/validate',
        data: {'code': promoCode},
      );

      if (response.statusCode == 200) {
        final discount = (response.data['discount'] as num).toDouble();
        await localDataSource.savePromoCode(promoCode, discount);
        return await getCart();
      }

      return const Left(ServerFailure('Invalid promo code'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> removePromoCode() async {
    try {
      await localDataSource.clearPromoCode();
      return await getCart();
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getCartItemCount() async {
    try {
      final cartResult = await getCart();
      return cartResult.fold(
        (failure) => Left(failure),
        (cart) => Right(cart.itemCount),
      );
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkAndClearExpiredCart(
    Duration expirationDuration,
  ) async {
    try {
      final cartResult = await getCart();
      return await cartResult.fold(
        (failure) => Left(failure),
        (cart) async {
          if (cart.isExpired) {
            await clearCart();
            return const Right(true); // Cart was expired and cleared
          }
          return const Right(false); // Cart is still valid
        },
      );
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, bool>>> checkItemsAvailability() async {
    try {
      final items = await localDataSource.getCartItems();
      final itemIds = items.map((item) => item.menuItemId).toList();

      if (itemIds.isEmpty) {
        return const Right({});
      }

      // Call API to check availability
      final response = await apiClient.post(
        '/menu/check-availability',
        data: {'item_ids': itemIds},
      );

      if (response.statusCode == 200) {
        final availabilityMap = Map<String, bool>.from(
          response.data['availability'] as Map,
        );
        return Right(availabilityMap);
      }

      return const Left(ServerFailure('Failed to check availability'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> validateCartRestaurant(
    String restaurantId,
  ) async {
    try {
      final cartResult = await getCart();
      return cartResult.fold(
        (failure) => Left(failure),
        (cart) {
          final canAdd = cart.canAddItemFromRestaurant(restaurantId);
          return Right(canAdd);
        },
      );
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
