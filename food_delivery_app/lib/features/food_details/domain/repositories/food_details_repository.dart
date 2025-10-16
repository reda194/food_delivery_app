import '../../../restaurant_details/domain/entities/menu_item_entity.dart';
import '../entities/ingredient_entity.dart';

/// Food Details Repository Interface
abstract class FoodDetailsRepository {
  /// Get menu item details with full nutritional information
  Future<MenuItemEntity> getMenuItemDetails(String menuItemId);

  /// Get ingredients for a menu item
  Future<List<IngredientEntity>> getMenuItemIngredients(String menuItemId);

  /// Check if menu item is favorited by current user
  Future<bool> isMenuItemFavorited(String menuItemId);

  /// Toggle favorite status for a menu item
  Future<void> toggleMenuItemFavorite(String menuItemId);

  /// Get nutritional information for a menu item
  Future<Map<String, dynamic>> getMenuItemNutrition(String menuItemId);
}
