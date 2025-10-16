import 'package:equatable/equatable.dart';
import '../../../restaurant_details/domain/entities/menu_item_entity.dart';

/// Food Details Event Base Class
abstract class FoodDetailsEvent extends Equatable {
  const FoodDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// Load Food Details Event
class LoadFoodDetailsEvent extends FoodDetailsEvent {
  final String menuItemId;

  const LoadFoodDetailsEvent(this.menuItemId);

  @override
  List<Object?> get props => [menuItemId];
}

/// Set Menu Item Event (when passing menu item directly)
class SetMenuItemEvent extends FoodDetailsEvent {
  final MenuItemEntity menuItem;

  const SetMenuItemEvent(this.menuItem);

  @override
  List<Object?> get props => [menuItem];
}

/// Update Quantity Event
class UpdateQuantityEvent extends FoodDetailsEvent {
  final int quantity;

  const UpdateQuantityEvent(this.quantity);

  @override
  List<Object?> get props => [quantity];
}

/// Increment Quantity Event
class IncrementQuantityEvent extends FoodDetailsEvent {}

/// Decrement Quantity Event
class DecrementQuantityEvent extends FoodDetailsEvent {}

/// Toggle Favorite Event
class ToggleFavoriteEvent extends FoodDetailsEvent {}

/// Load Ingredients Event
class LoadIngredientsEvent extends FoodDetailsEvent {
  final String menuItemId;

  const LoadIngredientsEvent(this.menuItemId);

  @override
  List<Object?> get props => [menuItemId];
}

/// Add To Cart Event
class AddToCartEvent extends FoodDetailsEvent {}
