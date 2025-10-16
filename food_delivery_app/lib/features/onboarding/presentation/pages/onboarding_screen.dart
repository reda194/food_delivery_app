import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/routes/route_names.dart';

/// Onboarding Screen - Single page introducing the app
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _navigateToSignUp(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(RouteNames.register);
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2), // Light cream/beige background from Figma
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space24,
            vertical: AppDimensions.space32,
          ),
          child: Column(
            children: [
              // Spacer to push content down slightly
              const SizedBox(height: AppDimensions.space40),

              // Illustration
              Expanded(
                flex: 3,
                child: Center(
                  child: Image.asset(
                    AppImages.delivery,
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
              const Text(
                'Browse Your Menu\n& Order Directly',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.space16),

              // Subtitle
              Text(
                'The best food delivery food app you\nhave ever used!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _navigateToSignUp(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                      side: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.space16),

              // Log In Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => _navigateToLogin(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF8E7), // Light cream/yellow
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey[300]!, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                    ),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.space24),
            ],
          ),
        ),
      ),
    );
  }
}
