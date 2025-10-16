import 'package:hive/hive.dart';
import '../models/cart_item_model.dart';

/// Cart Local Data Source - Abstract interface
abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addCartItem(CartItemModel item);
  Future<void> updateCartItem(CartItemModel item);
  Future<void> removeCartItem(String itemId);
  Future<void> clearCart();
  Future<String?> getPromoCode();
  Future<double?> getPromoDiscount();
  Future<void> savePromoCode(String code, double discount);
  Future<void> clearPromoCode();
}

/// Cart Local Data Source Implementation using Hive
class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String _cartBoxName = 'cart_box';
  static const String _promoBoxName = 'promo_box';
  static const String _promoCodeKey = 'promo_code';
  static const String _promoDiscountKey = 'promo_discount';

  Box<CartItemModel>? _cartBox;
  Box? _promoBox;

  Future<Box<CartItemModel>> get cartBox async {
    if (_cartBox != null && _cartBox!.isOpen) {
      return _cartBox!;
    }
    _cartBox = await Hive.openBox<CartItemModel>(_cartBoxName);
    return _cartBox!;
  }

  Future<Box> get promoBox async {
    if (_promoBox != null && _promoBox!.isOpen) {
      return _promoBox!;
    }
    _promoBox = await Hive.openBox(_promoBoxName);
    return _promoBox!;
  }

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final box = await cartBox;
      return box.values.toList();
    } catch (e) {
      throw Exception('Failed to get cart items: $e');
    }
  }

  @override
  Future<void> addCartItem(CartItemModel item) async {
    try {
      final box = await cartBox;

      // Check if item already exists
      final existingItemKey = box.keys.firstWhere(
        (key) => box.get(key)?.menuItemId == item.menuItemId,
        orElse: () => null,
      );

      if (existingItemKey != null) {
        // Update quantity of existing item
        final existingItem = box.get(existingItemKey)!;
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity + item.quantity,
        );
        await box.put(existingItemKey, updatedItem);
      } else {
        // Add new item
        await box.put(item.id, item);
      }
    } catch (e) {
      throw Exception('Failed to add cart item: $e');
    }
  }

  @override
  Future<void> updateCartItem(CartItemModel item) async {
    try {
      final box = await cartBox;
      await box.put(item.id, item);
    } catch (e) {
      throw Exception('Failed to update cart item: $e');
    }
  }

  @override
  Future<void> removeCartItem(String itemId) async {
    try {
      final box = await cartBox;
      await box.delete(itemId);
    } catch (e) {
      throw Exception('Failed to remove cart item: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      final box = await cartBox;
      await box.clear();
      await clearPromoCode();
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  @override
  Future<String?> getPromoCode() async {
    try {
      final box = await promoBox;
      return box.get(_promoCodeKey) as String?;
    } catch (e) {
      throw Exception('Failed to get promo code: $e');
    }
  }

  @override
  Future<double?> getPromoDiscount() async {
    try {
      final box = await promoBox;
      return box.get(_promoDiscountKey) as double?;
    } catch (e) {
      throw Exception('Failed to get promo discount: $e');
    }
  }

  @override
  Future<void> savePromoCode(String code, double discount) async {
    try {
      final box = await promoBox;
      await box.put(_promoCodeKey, code);
      await box.put(_promoDiscountKey, discount);
    } catch (e) {
      throw Exception('Failed to save promo code: $e');
    }
  }

  @override
  Future<void> clearPromoCode() async {
    try {
      final box = await promoBox;
      await box.delete(_promoCodeKey);
      await box.delete(_promoDiscountKey);
    } catch (e) {
      throw Exception('Failed to clear promo code: $e');
    }
  }
}
