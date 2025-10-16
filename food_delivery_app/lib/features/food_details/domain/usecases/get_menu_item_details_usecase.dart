import '../repositories/food_details_repository.dart';
import '../../../restaurant_details/domain/entities/menu_item_entity.dart';

/// Get Menu Item Details Use Case
class GetMenuItemDetailsUseCase {
  final FoodDetailsRepository repository;

  GetMenuItemDetailsUseCase(this.repository);

  Future<MenuItemEntity> call(String menuItemId) async {
    if (menuItemId.isEmpty) {
      throw ArgumentError('Menu item ID cannot be empty');
    }

    return await repository.getMenuItemDetails(menuItemId);
  }
}
