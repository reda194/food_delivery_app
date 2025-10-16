import '../repositories/food_details_repository.dart';
import '../entities/ingredient_entity.dart';

/// Get Menu Item Ingredients Use Case
class GetMenuItemIngredientsUseCase {
  final FoodDetailsRepository repository;

  GetMenuItemIngredientsUseCase(this.repository);

  Future<List<IngredientEntity>> call(String menuItemId) async {
    if (menuItemId.isEmpty) {
      throw ArgumentError('Menu item ID cannot be empty');
    }

    return await repository.getMenuItemIngredients(menuItemId);
  }
}
