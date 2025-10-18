import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/onboarding_page_entity.dart';

/// Widget to display a single onboarding page
class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageEntity page;

  const OnboardingPageWidget({
    super.key,
    required this.page,
  });

  Color _parseColor(String? colorHex) {
    if (colorHex == null) return const Color(0xFFFAF7F2);

    final hex = colorHex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _parseColor(page.backgroundColor),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space24,
        vertical: AppDimensions.space32,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Illustration
          Expanded(
            flex: 3,
            child: Center(
              child: Image.asset(
                page.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if image not found
                  return Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(150),
                    ),
                    child: Icon(
                      Icons.delivery_dining,
                      size: 120,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.space40),

          // Title
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              height: 1.2,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.space16),

          // Description
          Text(
            page.description,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
