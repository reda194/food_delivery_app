import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../../../features/cart/presentation/bloc/cart_event.dart' as cart;
import '../../../../features/cart/domain/entities/cart_item_entity.dart';
import '../../../restaurant_details/domain/entities/menu_item_entity.dart';
import '../bloc/food_details_bloc.dart';
import '../bloc/food_details_event.dart';
import '../bloc/food_details_state.dart';
import '../../domain/entities/ingredient_entity.dart';

/// Food Details Screen - Matches Figma design
class FoodDetailsScreen extends StatelessWidget {
  final MenuItemEntity menuItem;

  const FoodDetailsScreen({
    super.key,
    required this.menuItem,
  });

  @override
  Widget build(BuildContext context) {
    // Set the menu item in the bloc when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodDetailsBloc>().add(SetMenuItemEvent(menuItem));
    });

    return BlocListener<FoodDetailsBloc, FoodDetailsState>(
      listener: (context, state) {
        if (state is AddedToCart) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Added to cart'),
              duration: Duration(seconds: 2),
            ),
          );
        } else if (state is FoodDetailsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<FoodDetailsBloc, FoodDetailsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFFAF7F2),
            body: SafeArea(
              child: Column(
                children: [
                  // Main Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppDimensions.space16),

                          // Top Bar: Back Button, Title, Bookmark
                          _buildTopBar(context, state),

                          const SizedBox(height: AppDimensions.space32),

                          // Food Name and Price
                          _buildFoodNameAndPrice(state),

                          const SizedBox(height: AppDimensions.space40),

                          // Food Image with Page Indicator
                          _buildFoodImage(context),

                          const SizedBox(height: AppDimensions.space40),

                          // Ingredients Section
                          _buildIngredientsSection(state),

                          const SizedBox(height: AppDimensions.space40),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Action Bar
                  _buildBottomActionBar(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, FoodDetailsState state) {
    bool isFavorited = false;
    if (state is FoodDetailsLoaded) {
      isFavorited = state.isFavorited;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),

          // Title
          const Text(
            'Food Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          // Bookmark Button
          GestureDetector(
            onTap: () {
              context.read<FoodDetailsBloc>().add(ToggleFavoriteEvent());
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isFavorited ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodNameAndPrice(FoodDetailsState state) {
    MenuItemEntity currentMenuItem = menuItem;
    if (state is FoodDetailsLoaded) {
      currentMenuItem = state.menuItem;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Name
          Expanded(
            child: Text(
              currentMenuItem.name,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                height: 1.1,
                letterSpacing: -1,
              ),
            ),
          ),

          // Price
          Text(
            '\$${currentMenuItem.finalPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodImage(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Food Image Container
          Container(
            width: MediaQuery.of(context).size.width - 48,
            height: 350,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E7),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Image.asset(
                'assets/images/burger.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.fastfood,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.space16),

          // Page Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsSection(FoodDetailsState state) {
    List<IngredientEntity> ingredients = [];
    
    if (state is FoodDetailsLoaded) {
      ingredients = state.ingredients;
    } else {
      // Default ingredients for initial state
      ingredients = [
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
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ingredients.map((ingredient) {
          return _buildIngredientCard(
            icon: ingredient.icon,
            name: ingredient.name,
            calories: ingredient.calories,
            backgroundColor: Color(int.parse(ingredient.colorHex.replaceFirst('#', '0xFF'))),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, FoodDetailsState state) {
    int quantity = 1;
    bool isAddingToCart = false;
    
    if (state is FoodDetailsLoaded) {
      quantity = state.quantity;
    } else if (state is AddingToCart) {
      quantity = state.quantity;
      isAddingToCart = true;
    }

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space24),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7F2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Quantity Controls
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E7),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                // Bag Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF8E7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Quantity Stepper (Chevrons)
          Row(
            children: [
              GestureDetector(
                onTap: quantity > 1
                    ? () => context.read<FoodDetailsBloc>().add(DecrementQuantityEvent())
                    : null,
                child: Icon(
                  Icons.chevron_left,
                  color: quantity > 1 ? Colors.black : Colors.grey[400],
                  size: 32,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: quantity < 99
                    ? () => context.read<FoodDetailsBloc>().add(IncrementQuantityEvent())
                    : null,
                child: Icon(
                  Icons.chevron_right,
                  color: quantity < 99 ? Colors.black : Colors.grey[400],
                  size: 32,
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Add to Cart Button
          Expanded(
            child: GestureDetector(
              onTap: isAddingToCart
                  ? null
                  : () {
                      // Handle add to cart
                      context.read<FoodDetailsBloc>().add(AddToCartEvent());
                      
                      // Also add to cart using CartBloc
                      if (state is FoodDetailsLoaded) {
                        final cartItem = CartItemEntity(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          menuItemId: state.menuItem.id,
                          menuItemName: state.menuItem.name,
                          menuItemImage: state.menuItem.imageUrl,
                          price: state.menuItem.finalPrice,
                          quantity: state.quantity,
                          restaurantId: 'restaurant_1', // In a real app, get from menu item
                          restaurantName: 'Restaurant', // In a real app, get from menu item
                          addedAt: DateTime.now(),
                        );

                        context.read<CartBloc>().add(cart.AddToCartEvent(cartItem));
                      }
                    },
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: isAddingToCart ? Colors.grey[300] : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Center(
                  child: isAddingToCart
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Text(
                          'Add To Cart',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientCard({
    required String icon,
    required String name,
    required int calories,
    required Color backgroundColor,
  }) {
    return Column(
      children: [
        // Ingredient Icon Circle
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              icon,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Ingredient Name
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 4),

        // Calories
        Text(
          '${calories}cal',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
