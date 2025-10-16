import '../repositories/food_details_repository.dart';

/// Toggle Favorite Use Case
class ToggleFavoriteUseCase {
  final FoodDetailsRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<void> call(String menuItemId) async {
    if (menuItemId.isEmpty) {
      throw ArgumentError('Menu item ID cannot be empty');
    }

    await repository.toggleMenuItemFavorite(menuItemId);
  }
}
