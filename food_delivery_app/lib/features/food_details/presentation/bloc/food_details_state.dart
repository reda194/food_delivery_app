import 'package:equatable/equatable.dart';
import '../../../restaurant_details/domain/entities/menu_item_entity.dart';
import '../../domain/entities/ingredient_entity.dart';

/// Food Details State Base Class
abstract class FoodDetailsState extends Equatable {
  const FoodDetailsState();

  @override
  List<Object?> get props => [];
}

/// Food Details Initial State
class FoodDetailsInitial extends FoodDetailsState {}

/// Food Details Loading State
class FoodDetailsLoading extends FoodDetailsState {}

/// Food Details Loaded State
class FoodDetailsLoaded extends FoodDetailsState {
  final MenuItemEntity menuItem;
  final int quantity;
  final bool isFavorited;
  final List<IngredientEntity> ingredients;

  const FoodDetailsLoaded({
    required this.menuItem,
    this.quantity = 1,
    this.isFavorited = false,
    this.ingredients = const [],
  });

  FoodDetailsLoaded copyWith({
    MenuItemEntity? menuItem,
    int? quantity,
    bool? isFavorited,
    List<IngredientEntity>? ingredients,
  }) {
    return FoodDetailsLoaded(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      isFavorited: isFavorited ?? this.isFavorited,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  @override
  List<Object?> get props => [
        menuItem,
        quantity,
        isFavorited,
        ingredients,
      ];
}

/// Food Details Error State
class FoodDetailsError extends FoodDetailsState {
  final String message;

  const FoodDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Adding To Cart State
class AddingToCart extends FoodDetailsState {
  final MenuItemEntity menuItem;
  final int quantity;

  const AddingToCart({
    required this.menuItem,
    required this.quantity,
  });

  @override
  List<Object?> get props => [menuItem, quantity];
}

/// Added To Cart State
class AddedToCart extends FoodDetailsState {
  final MenuItemEntity menuItem;
  final int quantity;

  const AddedToCart({
    required this.menuItem,
    required this.quantity,
  });

  @override
  List<Object?> get props => [menuItem, quantity];
}
