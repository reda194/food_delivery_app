import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../../../features/cart/presentation/bloc/cart_event.dart';
import '../../../../features/cart/domain/entities/cart_item_entity.dart';
import '../../../restaurant_details/domain/entities/menu_item_entity.dart';

/// Food Details Screen - Matches Figma design
class FoodDetailsScreen extends StatefulWidget {
  final MenuItemEntity menuItem;

  const FoodDetailsScreen({
    super.key,
    required this.menuItem,
  });

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  int _quantity = 1;

  // Ingredients data (in a real app, this would come from the menu item entity)
  final List<Map<String, dynamic>> _ingredients = [
    {
      'name': 'Meat',
      'icon': '🥩',
      'calories': 30,
      'color': const Color(0xFFFFE8E8),
    },
    {
      'name': 'Cheese',
      'icon': '🧀',
      'calories': 10,
      'color': const Color(0xFFFFF8E7),
    },
    {
      'name': 'Green Leaf',
      'icon': '🥬',
      'calories': 22,
      'color': const Color(0xFFE8F5E9),
    },
    {
      'name': 'Tomato',
      'icon': '🍅',
      'calories': 22,
      'color': const Color(0xFFFFEBEE),
    },
  ];

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _addToCart() {
    final cartItem = CartItemEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      menuItemId: widget.menuItem.id,
      menuItemName: widget.menuItem.name,
      menuItemImage: widget.menuItem.imageUrl,
      price: widget.menuItem.finalPrice,
      quantity: _quantity,
      restaurantId: 'restaurant_1', // In a real app, get from menu item
      restaurantName: 'Restaurant', // In a real app, get from menu item
      addedAt: DateTime.now(),
    );

    context.read<CartBloc>().add(AddToCartEvent(cartItem));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2), // Light cream background from Figma
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
                    Padding(
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
                              // Handle bookmark
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.bookmark_border,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppDimensions.space32),

                    // Food Name and Price
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Food Name
                          Expanded(
                            child: Text(
                              widget.menuItem.name,
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
                            '\$${widget.menuItem.finalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppDimensions.space40),

                    // Food Image with Page Indicator
                    Center(
                      child: Column(
                        children: [
                          // Food Image Container
                          Container(
                            width: MediaQuery.of(context).size.width - 48,
                            height: 350,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8E7), // Light cream
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Image.asset(
                                'assets/images/burer.png',
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
                    ),

                    const SizedBox(height: AppDimensions.space40),

                    // Ingredients Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _ingredients.map((ingredient) {
                          return _buildIngredientCard(
                            icon: ingredient['icon'],
                            name: ingredient['name'],
                            calories: ingredient['calories'],
                            backgroundColor: ingredient['color'],
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.space40),
                  ],
                ),
              ),
            ),

            // Bottom Action Bar
            Container(
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
                      color: const Color(0xFFFFF8E7), // Light cream
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
                        onTap: _decrementQuantity,
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.black,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _incrementQuantity,
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.grey[400],
                          size: 32,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  // Add to Cart Button
                  Expanded(
                    child: GestureDetector(
                      onTap: _addToCart,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: const Center(
                          child: Text(
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
            ),
          ],
        ),
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
