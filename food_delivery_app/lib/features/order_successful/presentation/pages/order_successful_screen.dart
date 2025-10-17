import 'package:flutter/material.dart';
import '../../../../core/routes/route_names.dart';

/// Order Successful Screen - Matches Figma design exactly
/// Shows success message after order placement
class OrderSuccessfulScreen extends StatelessWidget {
  final String? orderId;
  final String? driverName;
  final String? driverPhone;
  final String? driverImage;
  final String? driverOrderId;
  final String? deliveryAddress;
  final int? estimatedMinutes;

  const OrderSuccessfulScreen({
    super.key,
    this.orderId,
    this.driverName,
    this.driverPhone,
    this.driverImage,
    this.driverOrderId,
    this.deliveryAddress,
    this.estimatedMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Success Illustration
              Container(
                width: 280,
                height: 280,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF4E6),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Package Box
                    Positioned(
                      left: 40,
                      bottom: 80,
                      child: Transform.rotate(
                        angle: -0.1,
                        child: Container(
                          width: 100,
                          height: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB84D),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Box tape
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 20,
                                  color: const Color(0xFFE8A040),
                                ),
                              ),
                              // Location pin on box
                              Positioned(
                                top: 25,
                                left: 35,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Color(0xFFFF6B6B),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Clipboard with Checkmarks
                    Positioned(
                      right: 30,
                      top: 60,
                      child: Transform.rotate(
                        angle: 0.15,
                        child: Container(
                          width: 110,
                          height: 140,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8DC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFD4A574),
                              width: 8,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Check mark 1
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check,
                                    color: Color(0xFF4CAF50),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 40,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Check mark 2
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check,
                                    color: Color(0xFFFF9999),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 40,
                                    height: 3,
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
                      ),
                    ),

                    // Pencil
                    Positioned(
                      right: 20,
                      top: 30,
                      child: Transform.rotate(
                        angle: 0.5,
                        child: Container(
                          width: 12,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFFFD700),
                                Color(0xFF8BC34A),
                                Color(0xFF4CAF50),
                              ],
                              stops: [0.0, 0.3, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: [
                              const Spacer(),
                              // Pencil tip
                              CustomPaint(
                                size: const Size(12, 15),
                                painter: _PencilTipPainter(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Location Pin (floating)
                    Positioned(
                      left: 50,
                      top: 50,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9999),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Title
              const Text(
                'Order Successful',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  letterSpacing: -1,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Subtitle
              Text(
                'Your order is successfully placed. Chill and\nwait your food will deliver soon!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 3),

              // Track Order Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to order tracking with parameters
                    Navigator.pushReplacementNamed(
                      context,
                      RouteNames.orderTracking,
                      arguments: {
                        'orderId': orderId,
                        'driverName': driverName,
                        'driverPhone': driverPhone,
                        'driverImage': driverImage,
                        'driverOrderId': driverOrderId,
                        'deliveryAddress': deliveryAddress,
                        'estimatedMinutes': estimatedMinutes,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF8E7),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    'Track Order',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for pencil tip
class _PencilTipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
