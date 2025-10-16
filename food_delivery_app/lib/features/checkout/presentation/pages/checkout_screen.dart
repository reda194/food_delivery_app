import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../bloc/checkout_bloc.dart';
import '../bloc/checkout_event.dart';
import '../bloc/checkout_state.dart';

/// Checkout Screen - Matches Figma design with dark theme
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedAddress = 'home';
  String _selectedPayment = 'card';

  @override
  void initState() {
    super.initState();
    context.read<CheckoutBloc>().add(const LoadCheckoutDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background from Figma
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is OrderPlaced) {
            Navigator.pushReplacementNamed(
              context,
              '/order-successful',
              arguments: {
                'orderId': state.order.id,
                'totalAmount': state.order.total,
                'estimatedDeliveryTime': '30-45 mins',
              },
            );
          } else if (state is OrderPlacementFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CheckoutLoading || state is PlacingOrder) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (state is CheckoutLoaded) {
            final cart = state.cart;

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
                        'Checkout',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space40),

                  // Address Section
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.space24,
                      ),
                      children: [
                        // Address Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Address',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate to add address
                              },
                              child: const Text(
                                'Add New Location',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // My Home
                        _buildAddressOption(
                          icon: '📍',
                          title: 'My Home',
                          subtitle: 'Housing Estate, 25/3, Sylhet, BD',
                          value: 'home',
                        ),

                        const SizedBox(height: 16),

                        // My Office
                        _buildAddressOption(
                          icon: '📍',
                          title: 'My Office',
                          subtitle: 'Housing Estate, 25/3, Sylhet, BD',
                          value: 'office',
                        ),

                        const SizedBox(height: 40),

                        // Payment Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Payment',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate to add card
                              },
                              child: const Text(
                                'Add New Card',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Master Card
                        _buildPaymentOption(
                          icon: Icons.credit_card,
                          iconColor: const Color(0xFFFF9800),
                          title: 'Master Card',
                          subtitle: '5623 2347 2589 112',
                          value: 'card',
                        ),

                        const SizedBox(height: 16),

                        // Cash on Delivery
                        _buildPaymentOption(
                          icon: Icons.delivery_dining,
                          iconColor: Colors.grey,
                          title: 'Cash On Delivery',
                          subtitle: 'Pay by cash on delivery',
                          value: 'cash',
                        ),

                        const SizedBox(height: 40),

                        // Subtotal
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sub Total :',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[500],
                                ),
                              ),
                              Text(
                                '${cart.subtotal.toStringAsFixed(2)} US\$',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Divider
                        Divider(
                          color: Colors.grey[800],
                          thickness: 1,
                          height: 32,
                        ),

                        // Total
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total :',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[500],
                                ),
                              ),
                              Text(
                                '(${cart.itemCount} Items) ${cart.total.toStringAsFixed(2)} US\$',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),

                  // Place Order Button
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

                        // Place Order Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              context.read<CheckoutBloc>().add(const PlaceOrderEvent());
                            },
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: const Center(
                                child: Text(
                                  'Place Order',
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

          return const Center(
            child: Text(
              'Error loading checkout',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddressOption({
    required String icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    final isSelected = _selectedAddress == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAddress = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? Border.all(color: Colors.white, width: 2)
              : null,
        ),
        child: Row(
          children: [
            // Map Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Address Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            // Radio Button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.grey[600]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String value,
  }) {
    final isSelected = _selectedPayment == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPayment = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? Border.all(color: Colors.white, width: 2)
              : null,
        ),
        child: Row(
          children: [
            // Payment Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            // Payment Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            // Radio Button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.grey[600]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
