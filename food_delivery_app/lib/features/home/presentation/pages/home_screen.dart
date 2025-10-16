import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../../../features/cart/presentation/bloc/cart_state.dart';
import '../../../restaurant_details/domain/entities/menu_item_entity.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

/// Home Screen - Matches Figma design
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2), // Light cream background from Figma
      body: SafeArea(
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                // Main Content
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100), // Space for bottom cart bar
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppDimensions.space24),

                      // Top Bar: Menu Icon and Profile Picture
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Menu Icon (3 circles)
                            GestureDetector(
                              onTap: () {
                                // Open menu/drawer
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Profile Picture
                            GestureDetector(
                              onTap: () {
                                // Navigate to profile
                              },
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/profile.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.person,
                                          size: 32,
                                          color: Colors.grey[600],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDimensions.space40),

                      // Title
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.space24),
                        child: Text(
                          'Order Your\nFavorite Food',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            height: 1.1,
                            letterSpacing: -1,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDimensions.space32),

                      // Category Chips
                      SizedBox(
                        height: 56,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
                          children: [
                            // All Category
                            _buildCategoryChip(
                              label: 'All',
                              isSelected: true,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              onTap: () {},
                            ),
                            const SizedBox(width: 12),

                            // Drink Category
                            _buildCategoryChip(
                              label: 'Drink',
                              isSelected: false,
                              backgroundColor: const Color(0xFFFDE8F5),
                              textColor: const Color(0xFFE91E8E),
                              icon: '🥤',
                              iconBackgroundColor: const Color(0xFFFCB5E1),
                              onTap: () {},
                            ),
                            const SizedBox(width: 12),

                            // Burger Category
                            _buildCategoryChip(
                              label: 'Burger',
                              isSelected: false,
                              backgroundColor: const Color(0xFFFFF4E6),
                              textColor: const Color(0xFFFF9800),
                              icon: '🍔',
                              iconBackgroundColor: const Color(0xFFFFCC80),
                              onTap: () {},
                            ),
                            const SizedBox(width: 12),

                            // Pizza Category
                            _buildCategoryChip(
                              label: 'Pizza',
                              isSelected: false,
                              backgroundColor: const Color(0xFFE8F5E9),
                              textColor: const Color(0xFF4CAF50),
                              icon: '🍕',
                              iconBackgroundColor: const Color(0xFF81C784),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDimensions.space32),

                      // Food Category Cards
                      if (state is HomeLoaded) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
                          child: _buildFoodCategoryCard(
                            context: context,
                            title: 'Burgers',
                            itemCount: '517 Items',
                            imagePath: 'assets/images/burer.png',
                            categoryName: 'Burgers',
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space24),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
                          child: _buildFoodCategoryCard(
                            context: context,
                            title: 'Pizza',
                            itemCount: '328 Items',
                            imagePath: 'assets/images/Mini Burger.png',
                            categoryName: 'Pizza',
                          ),
                        ),
                      ],

                      // Loading State
                      if (state is HomeLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                        ),

                      // Error State
                      if (state is HomeError)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: AppDimensions.space40),
                    ],
                  ),
                ),

                // Bottom Cart Bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BlocBuilder<CartBloc, CartState>(
                    builder: (context, cartState) {
                      if (cartState is CartLoaded && cartState.cart.items.isNotEmpty) {
                        return _buildBottomCartBar(
                          context,
                          cartState.cart.itemCount,
                          cartState.cart.items,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required Color backgroundColor,
    required Color textColor,
    String? icon,
    Color? iconBackgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodCategoryCard({
    required BuildContext context,
    required String title,
    required String itemCount,
    required String imagePath,
    required String categoryName,
  }) {
    // Create mock items for the category
    final mockItems = List.generate(
      155,
      (index) => MenuItemEntity(
        id: 'burger_$index',
        name: index % 4 == 0
            ? 'Beef Burger'
            : index % 4 == 1
                ? 'Cheese Bust'
                : index % 4 == 2
                    ? 'Peparini Moo'
                    : 'Spicy Beast',
        description: index % 4 == 0
            ? 'Meat Cheese Burger'
            : index % 4 == 1
                ? 'Double Cheese Burger'
                : index % 4 == 2
                    ? 'Peperoni Burger'
                    : 'Double Cheese Burger',
        price: index % 2 == 0 ? 12.67 : 10.67,
        imageUrl: 'assets/images/burer.png',
        categoryId: 'burgers',
        categoryName: categoryName,
        calories: 500 + (index * 10),
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteNames.category,
          arguments: {
            'categoryName': categoryName,
            'items': mockItems,
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: 400,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E7), // Light cream/beige from Figma
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            // Food Image
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    imagePath,
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
            ),

            // Category Title
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),

            // Item Count
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                itemCount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCartBar(BuildContext context, int itemCount, List items) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          // Item Count Badge
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                itemCount.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Cart Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Cart',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$itemCount Items',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),

          // Cart Item Preview Images (up to 3)
          Row(
            children: List.generate(
              itemCount > 3 ? 3 : itemCount,
              (index) {
                return Container(
                  margin: EdgeInsets.only(left: index > 0 ? 8 : 0),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/burer.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.fastfood,
                            size: 24,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
