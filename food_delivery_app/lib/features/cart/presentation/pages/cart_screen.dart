import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/routes/route_names.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

/// Cart Screen - Matches Figma design with dark theme
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoCodeController = TextEditingController();

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background from Figma
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartItemRemoved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Item removed from cart'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            context.read<CartBloc>().add(const LoadCartEvent());
          } else if (state is PromoCodeApplied) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Promo code applied! ${state.discount.toStringAsFixed(0)}% off',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            _promoCodeController.clear();
            context.read<CartBloc>().add(const LoadCartEvent());
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (state is CartLoaded) {
            final cart = state.cart;

            if (cart.isEmpty) {
              return _buildEmptyCart(context);
            }

            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: AppDimensions.space16),

                  // Drag Handle
                  Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space32),

                  // Title
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimensions.space24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'My Orders',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space32),

                  // Cart Items List
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.space24,
                      ),
                      children: [
                        ...cart.items.map((item) {
                          return _buildCartItem(context, item, cart.items.indexOf(item));
                        }),
                      ],
                    ),
                  ),

                  // Promo Code Section
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space24,
                      vertical: AppDimensions.space16,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _promoCodeController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Apply Cupon Code',
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_promoCodeController.text.trim().isNotEmpty) {
                              context.read<CartBloc>().add(
                                    ApplyPromoCodeEvent(_promoCodeController.text),
                                  );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8E7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Apply',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bill Summary
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space24,
                    ),
                    padding: const EdgeInsets.all(AppDimensions.space24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        _buildBillRow(
                          'Subtotal',
                          '${cart.subtotal.toStringAsFixed(2)} US\$',
                        ),
                        const SizedBox(height: 12),
                        _buildBillRow(
                          'Shiping Fee',
                          'Standard - Free',
                        ),
                        const Divider(
                          color: Color(0xFF2A2A2A),
                          height: 32,
                          thickness: 1,
                        ),
                        _buildBillRow(
                          'Estimated Total',
                          '${cart.total.toStringAsFixed(2)} US\$ + Tax',
                          isBold: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space24),

                  // Checkout Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space24,
                    ),
                    child: Row(
                      children: [
                        // Bag Icon
                        Container(
                          width: 72,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E7),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Chevrons
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 32,
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey[700],
                          size: 32,
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey[800],
                          size: 32,
                        ),

                        const SizedBox(width: 16),

                        // Checkout Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, RouteNames.checkout);
                            },
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: const Center(
                                child: Text(
                                  'Checkout Now',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space32),
                ],
              ),
            );
          }

          return _buildEmptyCart(context);
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, dynamic item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          // Food Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/burer.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: Icon(
                      Icons.fastfood,
                      size: 40,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Name
                Text(
                  item.menuItemName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),

                // Item Description
                Text(
                  'Meat Cheese Burger',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 8),

                // Size
                Text(
                  'Size : M',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 8),

                // Quantity and Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Quantity : ${item.quantity}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),

                    // Price
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Actions (Heart and Delete)
          if (index == 1) ...[
            const SizedBox(width: 8),
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    context.read<CartBloc>().add(
                          RemoveFromCartEvent(item.id),
                        );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isBold ? Colors.white : Colors.grey[500],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.grey[700],
          ),
          const SizedBox(height: AppDimensions.space24),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppDimensions.space8),
          Text(
            'Add items to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: AppDimensions.space32),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, RouteNames.home);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFF8E7),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Browse Menu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
