import 'package:flutter/material.dart';

/// App Color Palette for Food Delivery Application
/// Following Material Design 3 principles with food delivery theme
class AppColors {
  AppColors._();

  // ==================== PRIMARY COLORS ====================
  /// Main brand color - Vibrant Orange for food delivery (like Swiggy/Zomato)
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryLight = Color(0xFFFF8C61);
  static const Color primaryDark = Color(0xFFE55420);

  /// Secondary brand color - Deep Teal for accents
  static const Color secondary = Color(0xFF00B894);
  static const Color secondaryLight = Color(0xFF00D9A8);
  static const Color secondaryDark = Color(0xFF009B7D);

  // ==================== NEUTRAL COLORS ====================
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  /// Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  // ==================== SEMANTIC COLORS ====================
  /// Success states (order confirmed, payment successful)
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);

  /// Warning states (pending orders, low stock)
  static const Color warning = Color(0xFFFFA726);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);

  /// Error states (failed payment, out of stock)
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color errorDark = Color(0xFFC62828);

  /// Info states (tips, notifications)
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  // ==================== UI ELEMENT COLORS ====================
  /// Borders
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFEEEEEE);
  static const Color borderDark = Color(0xFFBDBDBD);

  /// Dividers
  static const Color divider = Color(0xFFE0E0E0);

  /// Shadows
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowDark = Color(0x33000000);

  /// Overlays
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  static const Color overlayDark = Color(0xB3000000);

  /// Shimmer loading
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ==================== FOOD DELIVERY SPECIFIC ====================
  /// Restaurant ratings
  static const Color rating = Color(0xFFFFC107);
  static const Color ratingFilled = Color(0xFFFFB300);

  /// Delivery status colors
  static const Color orderPending = Color(0xFFFFA726);
  static const Color orderConfirmed = Color(0xFF66BB6A);
  static const Color orderPreparing = Color(0xFF42A5F5);
  static const Color orderOutForDelivery = Color(0xFF7E57C2);
  static const Color orderDelivered = Color(0xFF4CAF50);
  static const Color orderCancelled = Color(0xFFE53935);

  /// Food category colors (for visual differentiation)
  static const Color categoryPizza = Color(0xFFFF6B6B);
  static const Color categoryBurger = Color(0xFFFFBE0B);
  static const Color categorySushi = Color(0xFFFF006E);
  static const Color categoryDessert = Color(0xFFFB5607);
  static const Color categoryDrinks = Color(0xFF3A86FF);
  static const Color categoryHealthy = Color(0xFF06FFA5);

  /// Discount & Offers
  static const Color discount = Color(0xFFE91E63);
  static const Color offer = Color(0xFFFF6B35);
  static const Color freeDelivery = Color(0xFF00B894);

  // ==================== GRADIENT COLORS ====================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orderStatusGradient = LinearGradient(
    colors: [orderPreparing, orderOutForDelivery],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== OPACITY VARIATIONS ====================
  static Color withValues(Color color, double alphaOpacity) {
    return color.withValues(alpha: alphaOpacity);
  }

  static const double opacityHigh = 0.87;
  static const double opacityMedium = 0.60;
  static const double opacityDisabled = 0.38;
  static const double opacityDivider = 0.12;
}
