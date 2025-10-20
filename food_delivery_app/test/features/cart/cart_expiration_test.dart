import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/features/cart/domain/entities/cart_entity.dart';
import 'package:food_delivery_app/features/cart/domain/entities/cart_item_entity.dart';

void main() {
  group('Cart Expiration Tests', () {
    late CartEntity cart;
    late List<CartItemEntity> testItems;

    setUp(() {
      testItems = [
        CartItemEntity(
          id: '1',
          menuItemId: 'item1',
          menuItemName: 'Pizza',
          menuItemImage: 'image.jpg',
          price: 12.99,
          quantity: 2,
          restaurantId: 'rest1',
          restaurantName: 'Pizza Place',
          addedAt: DateTime.now(),
        ),
      ];
    });

    test('Cart should not be expired when just created', () {
      cart = CartEntity(
        items: testItems,
        lastUpdated: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );

      expect(cart.isExpired, false);
      expect(cart.isExpiringSoon, false);
    });

    test('Cart should be expired after expiration time', () {
      cart = CartEntity(
        items: testItems,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 25)),
        expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
      );

      expect(cart.isExpired, true);
    });

    test('Cart should be expiring soon within 1 hour', () {
      cart = CartEntity(
        items: testItems,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 23)),
        expiresAt: DateTime.now().add(const Duration(minutes: 30)),
      );

      expect(cart.isExpired, false);
      expect(cart.isExpiringSoon, true);
    });

    test('Cart should calculate time until expiration correctly', () {
      final expiresAt = DateTime.now().add(const Duration(hours: 2));
      cart = CartEntity(
        items: testItems,
        lastUpdated: DateTime.now(),
        expiresAt: expiresAt,
      );

      final timeUntilExpiration = cart.timeUntilExpiration;
      expect(timeUntilExpiration, isNotNull);
      expect(timeUntilExpiration!.inHours, closeTo(2, 1));
    });

    test('Cart without expiration should not be expired', () {
      cart = CartEntity(
        items: testItems,
        lastUpdated: DateTime.now(),
        // No expiresAt set
      );

      expect(cart.isExpired, false);
      expect(cart.isExpiringSoon, false);
      expect(cart.timeUntilExpiration, isNull);
    });

    test('copyWith should update timestamp when updateTimestamp is true', () {
      final now = DateTime.now();
      cart = CartEntity(
        items: testItems,
        lastUpdated: now.subtract(const Duration(hours: 1)),
        expiresAt: now.add(const Duration(hours: 23)),
      );

      final updatedCart = cart.copyWith(updateTimestamp: true);

      expect(updatedCart.lastUpdated, isNot(cart.lastUpdated));
      expect(
        updatedCart.lastUpdated!.isAfter(cart.lastUpdated!),
        true,
      );
    });
  });

  group('Cart Restaurant Validation Tests', () {
    late CartEntity cart;

    test('Empty cart should accept items from any restaurant', () {
      cart = const CartEntity(items: []);

      expect(cart.canAddItemFromRestaurant('rest1'), true);
      expect(cart.canAddItemFromRestaurant('rest2'), true);
    });

    test('Cart with items should only accept same restaurant', () {
      cart = CartEntity(
        items: [
          CartItemEntity(
            id: '1',
            menuItemId: 'item1',
            menuItemName: 'Pizza',
            menuItemImage: 'image.jpg',
            price: 12.99,
            quantity: 2,
            restaurantId: 'rest1',
            restaurantName: 'Pizza Place',
            addedAt: DateTime.now(),
          ),
        ],
      );

      expect(cart.canAddItemFromRestaurant('rest1'), true);
      expect(cart.canAddItemFromRestaurant('rest2'), false);
    });

    test('Cart should return correct restaurant ID and name', () {
      cart = CartEntity(
        items: [
          CartItemEntity(
            id: '1',
            menuItemId: 'item1',
            menuItemName: 'Pizza',
            menuItemImage: 'image.jpg',
            price: 12.99,
            quantity: 2,
            restaurantId: 'rest1',
            restaurantName: 'Pizza Place',
            addedAt: DateTime.now(),
          ),
        ],
      );

      expect(cart.restaurantId, 'rest1');
      expect(cart.restaurantName, 'Pizza Place');
    });
  });
}
