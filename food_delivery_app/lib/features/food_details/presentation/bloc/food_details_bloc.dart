import 'package:bloc/bloc.dart';
import '../../domain/repositories/food_details_repository.dart';
import '../../domain/usecases/get_menu_item_details_usecase.dart';
import '../../domain/usecases/get_menu_item_ingredients_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import 'food_details_event.dart';
import 'food_details_state.dart';

/// Food Details Bloc
class FoodDetailsBloc extends Bloc<FoodDetailsEvent, FoodDetailsState> {
  final GetMenuItemDetailsUseCase getMenuItemDetailsUseCase;
  final GetMenuItemIngredientsUseCase getMenuItemIngredientsUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final FoodDetailsRepository repository;

  FoodDetailsBloc({
    required this.getMenuItemDetailsUseCase,
    required this.getMenuItemIngredientsUseCase,
    required this.toggleFavoriteUseCase,
    required this.repository,
  }) : super(FoodDetailsInitial()) {
    on<LoadFoodDetailsEvent>(_onLoadFoodDetails);
    on<SetMenuItemEvent>(_onSetMenuItem);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<IncrementQuantityEvent>(_onIncrementQuantity);
    on<DecrementQuantityEvent>(_onDecrementQuantity);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<LoadIngredientsEvent>(_onLoadIngredients);
    on<AddToCartEvent>(_onAddToCart);
  }

  Future<void> _onLoadFoodDetails(
    LoadFoodDetailsEvent event,
    Emitter<FoodDetailsState> emit,
  ) async {
    emit(FoodDetailsLoading());

    try {
      final menuItem = await getMenuItemDetailsUseCase(event.menuItemId);
      final isFavorited = await repository.isMenuItemFavorited(event.menuItemId);

      add(LoadIngredientsEvent(event.menuItemId));

      emit(FoodDetailsLoaded(
        menuItem: menuItem,
        isFavorited: isFavorited,
      ));
    } catch (e) {
      emit(FoodDetailsError(e.toString()));
    }
  }

  Future<void> _onSetMenuItem(
    SetMenuItemEvent event,
    Emitter<FoodDetailsState> emit,
  ) async {
    emit(FoodDetailsLoading());

    try {
      final isFavorited = await repository.isMenuItemFavorited(event.menuItem.id);

      add(LoadIngredientsEvent(event.menuItem.id));

      emit(FoodDetailsLoaded(
        menuItem: event.menuItem,
        isFavorited: isFavorited,
      ));
    } catch (e) {
      emit(FoodDetailsError(e.toString()));
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<FoodDetailsState> emit,
  ) async {
    if (state is FoodDetailsLoaded) {
      final currentState = state as FoodDetailsLoaded;
      
      if (event.quantity > 0 && event.quantity <= 99) {
        emit(currentState.copyWith(quantity: event.quantity));
      }
    }
  }

  Future<void> _onIncrementQuantity(
    IncrementQuantityEvent event,
    Emitter<FoodDetailsState> emit,
  ) async {
    if (state is FoodDetailsLoaded) {
      final currentState = state as FoodDetailsLoaded;
      
      if (currentState.quantity < 99) {
        emit(currentState.copyWith(quantity: currentState.quantity + 1));
      }
    }
  }

  Future<void> _onDecrementQuantity(
    DecrementQuantityEvent event,
    Emitter<FoodDetailsState> emit,
  ) async {
    if (state is FoodDetailsLoaded) {
      final currentState = state as FoodDetailsLoaded;
      
      if (currentState.quantity > 1) {
        emit(currentState.copyWith(quantity: currentState.quantity - 1));
      }
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FoodDetailsState> emit,
  ) async {
    if (state is FoodDetailsLoaded) {
      final currentState = state as FoodDetailsLoaded;
      
      try {
        await toggleFavoriteUseCase(currentState.menuItem.id);
        final newFavoriteStatus = await repository.isMenuItemFavorited(currentState.menuItem.id);
        
        emit(currentState.copyWith(isFavorited: newFavoriteStatus));
      } catch (e) {
        // Handle error silently or emit error state
        emit(FoodDetailsError(e.toString()));
      }
    }
  }

  Future<void> _onLoadIngredients(
    LoadIngredientsEvent event,
    Emitter<FoodDetailsState> emit,
  ) async {
    if (state is FoodDetailsLoaded) {
      try {
        final ingredients = await getMenuItemIngredientsUseCase(event.menuItemId);
        
        final currentState = state as FoodDetailsLoaded;
        emit(currentState.copyWith(ingredients: ingredients));
      } catch (e) {
        // Continue without ingredients if loading fails
      }
    }
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<FoodDetailsState> emit,
  ) async {
    if (state is FoodDetailsLoaded) {
      final currentState = state as FoodDetailsLoaded;
      
      emit(AddingToCart(
        menuItem: currentState.menuItem,
        quantity: currentState.quantity,
      ));
      
      try {
        // The FoodDetailsBloc now manages the state, but the actual cart addition
        // will be handled by the CartBloc through the screen's event dispatching
        // This prepares the cart item data for the CartBloc to process

        emit(AddedToCart(
          menuItem: currentState.menuItem,
          quantity: currentState.quantity,
        ));

        // Return to loaded state
        emit(currentState);
      } catch (e) {
        emit(FoodDetailsError(e.toString()));
      }
    }
  }

  /// Get current loaded state or null
  FoodDetailsLoaded? get currentState {
    if (state is FoodDetailsLoaded) {
      return state as FoodDetailsLoaded;
    }
    return null;
  }
}
