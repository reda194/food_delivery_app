import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/menu_item_entity.dart';
import '../repositories/restaurant_details_repository.dart';

/// Get Menu Items Use Case
class GetMenuItemsUseCase {
  final RestaurantDetailsRepository repository;

  GetMenuItemsUseCase(this.repository);

  Future<Either<Failure, List<MenuItemEntity>>> call({
    required String restaurantId,
    String? categoryId,
  }) async {
    if (restaurantId.isEmpty) {
      return const Left(ValidationFailure('Restaurant ID cannot be empty'));
    }

    if (categoryId != null && categoryId.isNotEmpty) {
      return await repository.getMenuItemsByCategory(restaurantId, categoryId);
    }

    return await repository.getAllMenuItems(restaurantId);
  }
}
