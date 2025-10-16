import '../../domain/repositories/food_details_repository.dart';
import '../../../restaurant_details/domain/entities/menu_item_entity.dart';
import '../../domain/entities/ingredient_entity.dart';
import '../datasources/food_details_local_datasource.dart';

/// Food Details Repository Implementation
class FoodDetailsRepositoryImpl implements FoodDetailsRepository {
  final FoodDetailsLocalDataSource localDataSource;

  FoodDetailsRepositoryImpl({required this.localDataSource});

  @override
  Future<MenuItemEntity> getMenuItemDetails(String menuItemId) async {
    return await localDataSource.getMenuItemDetails(menuItemId);
  }

  @override
  Future<List<IngredientEntity>> getMenuItemIngredients(String menuItemId) async {
    return await localDataSource.getMenuItemIngredients(menuItemId);
  }

  @override
  Future<bool> isMenuItemFavorited(String menuItemId) async {
    return await localDataSource.isMenuItemFavorited(menuItemId);
  }

  @override
  Future<void> toggleMenuItemFavorite(String menuItemId) async {
    final currentStatus = await isMenuItemFavorited(menuItemId);
    await localDataSource.saveMenuItemFavorite(menuItemId, !currentStatus);
  }

  @override
  Future<Map<String, dynamic>> getMenuItemNutrition(String menuItemId) async {
    return await localDataSource.getMenuItemNutrition(menuItemId);
  }
}
