import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography System for Food Delivery App
/// Based on Material Design 3 type scale
class AppTextStyles {
  AppTextStyles._();

  // Font Family
  static const String fontFamily = 'Poppins';
  static const String fontFamilySecondary = 'Roboto';

  // ==================== DISPLAY STYLES ====================
  /// Extra large display text (Splash screens, empty states)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w700,
    height: 1.12,
    letterSpacing: -0.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w700,
    height: 1.16,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 1.22,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // ==================== HEADLINE STYLES ====================
  /// Page titles, screen headers
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.29,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // ==================== TITLE STYLES ====================
  /// Section titles, card headers
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.27,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.50,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.10,
    color: AppColors.textPrimary,
  );

  // ==================== BODY STYLES ====================
  /// Body text, descriptions
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    letterSpacing: 0.50,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.40,
    color: AppColors.textSecondary,
  );

  // ==================== LABEL STYLES ====================
  /// Button text, form labels, chips
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.10,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.50,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.50,
    color: AppColors.textSecondary,
  );

  // ==================== CUSTOM FOOD DELIVERY STYLES ====================
  /// Restaurant name style
  static const TextStyle restaurantName = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  /// Food item name
  static const TextStyle foodItemName = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.50,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  /// Price text
  static const TextStyle priceLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.primary,
  );

  static const TextStyle priceMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.primary,
  );

  static const TextStyle priceSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0,
    color: AppColors.primary,
  );

  /// Strikethrough price (original price in discounts)
  static const TextStyle priceStrikethrough = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0,
    color: AppColors.textTertiary,
    decoration: TextDecoration.lineThrough,
  );

  /// Rating text
  static const TextStyle rating = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0,
    color: AppColors.rating,
  );

  /// Delivery time
  static const TextStyle deliveryTime = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.38,
    letterSpacing: 0,
    color: AppColors.textSecondary,
  );

  /// Cuisine types
  static const TextStyle cuisineType = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.textSecondary,
  );

  /// Order status
  static const TextStyle orderStatus = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.10,
    color: AppColors.primary,
  );

  /// Discount badge
  static const TextStyle discountBadge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: 0.50,
    color: AppColors.textOnPrimary,
  );

  /// Caption for images, subtle information
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.45,
    letterSpacing: 0.40,
    color: AppColors.textTertiary,
  );

  // ==================== HELPER METHODS ====================
  /// Apply color to any text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Apply weight to any text style
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Apply custom letter spacing
  static TextStyle withLetterSpacing(TextStyle style, double spacing) {
    return style.copyWith(letterSpacing: spacing);
  }

  /// Apply custom line height
  static TextStyle withHeight(TextStyle style, double height) {
    return style.copyWith(height: height);
  }
}
