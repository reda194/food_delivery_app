import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

/// Primary Button Widget - Main CTA button used throughout the app
/// Supports loading state, disabled state, and custom styling
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool effectivelyDisabled = isDisabled || isLoading || onPressed == null;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppDimensions.buttonHeightMedium,
      child: ElevatedButton(
        onPressed: effectivelyDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.borderLight,
          disabledForegroundColor: AppColors.textDisabled,
          elevation: AppDimensions.buttonElevation,
          shadowColor: AppColors.shadow,
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: AppDimensions.buttonPaddingHorizontalMedium,
                vertical: AppDimensions.space16,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppDimensions.buttonRadius,
            ),
          ),
        ),
        child: _buildButtonChild(),
      ),
    );
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: AppDimensions.space8),
          Text(
            text,
            style: AppTextStyles.labelLarge.copyWith(
              color: textColor ?? AppColors.textOnPrimary,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: AppTextStyles.labelLarge.copyWith(
        color: textColor ?? AppColors.textOnPrimary,
      ),
    );
  }
}
