import '../../../restaurant_details/domain/entities/menu_item_entity.dart';
import '../../domain/entities/ingredient_entity.dart';

/// Food Details Local Data Source
abstract class FoodDetailsLocalDataSource {
  Future<MenuItemEntity> getMenuItemDetails(String menuItemId);
  Future<List<IngredientEntity>> getMenuItemIngredients(String menuItemId);
  Future<bool> isMenuItemFavorited(String menuItemId);
  Future<void> saveMenuItemFavorite(String menuItemId, bool isFavorited);
  Future<Map<String, dynamic>> getMenuItemNutrition(String menuItemId);
}

/// Food Details Local Data Source Implementation
class FoodDetailsLocalDataSourceImpl implements FoodDetailsLocalDataSource {
  // Mock data for local storage
  static final Map<String, MenuItemEntity> _menuItemsCache = {};
  static final Map<String, bool> _favoritesCache = {};
  static final Map<String, List<IngredientEntity>> _ingredientsCache = {};

  @override
  Future<MenuItemEntity> getMenuItemDetails(String menuItemId) async {
    // In a real app, this would fetch from local database or cache
    // For now, return cached item or throw error
    final item = _menuItemsCache[menuItemId];
    if (item != null) {
      return item;
    }
    throw Exception('Menu item not found in cache');
  }

  @override
  Future<List<IngredientEntity>> getMenuItemIngredients(String menuItemId) async {
    // Return cached ingredients or mock data
    final cached = _ingredientsCache[menuItemId];
    if (cached != null) {
      return cached;
    }

    // Mock ingredients
    final mockIngredients = [
      const IngredientEntity(
        id: '1',
        name: 'Meat',
        icon: '🥩',
        calories: 30,
        colorHex: '#FFE8E8',
      ),
      const IngredientEntity(
        id: '2',
        name: 'Cheese',
        icon: '🧀',
        calories: 10,
        colorHex: '#FFF8E7',
      ),
      const IngredientEntity(
        id: '3',
        name: 'Green Leaf',
        icon: '🥬',
        calories: 22,
        colorHex: '#E8F5E9',
      ),
      const IngredientEntity(
        id: '4',
        name: 'Tomato',
        icon: '🍅',
        calories: 22,
        colorHex: '#FFEBEE',
      ),
    ];

    _ingredientsCache[menuItemId] = mockIngredients;
    return mockIngredients;
  }

  @override
  Future<bool> isMenuItemFavorited(String menuItemId) async {
    return _favoritesCache[menuItemId] ?? false;
  }

  @override
  Future<void> saveMenuItemFavorite(String menuItemId, bool isFavorited) async {
    _favoritesCache[menuItemId] = isFavorited;
  }

  @override
  Future<Map<String, dynamic>> getMenuItemNutrition(String menuItemId) async {
    // Mock nutritional data
    return {
      'calories': 650,
      'protein': 35,
      'carbs': 45,
      'fat': 28,
      'fiber': 3,
      'sugar': 8,
      'sodium': 1200,
      'cholesterol': 85,
    };
  }

  /// Cache method for testing
  void cacheMenuItem(MenuItemEntity item) {
    _menuItemsCache[item.id] = item;
  }
}
