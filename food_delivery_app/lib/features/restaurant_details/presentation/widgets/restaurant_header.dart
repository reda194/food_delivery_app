import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/restaurant_details_entity.dart';

/// Restaurant Header Widget - Displays restaurant image and basic info
class RestaurantHeader extends StatelessWidget {
  final RestaurantDetailsEntity restaurant;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onBackTap;

  const RestaurantHeader({
    super.key,
    required this.restaurant,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(AppDimensions.space8),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: AppDimensions.iconSM,
          ),
        ),
        onPressed: onBackTap,
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(AppDimensions.space8),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppColors.error : AppColors.textPrimary,
              size: AppDimensions.iconSM,
            ),
          ),
          onPressed: onFavoriteTap,
        ),
        const SizedBox(width: AppDimensions.space8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Restaurant Image
            CachedNetworkImage(
              imageUrl: restaurant.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.surfaceVariant,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.surfaceVariant,
                child: const Icon(
                  Icons.restaurant,
                  size: 64,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            // Gradient Overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black38,
                  ],
                ),
              ),
            ),
            // Status Badge
            if (!restaurant.isOpen)
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space24,
                      vertical: AppDimensions.space12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(AppDimensions.chipRadius),
                    ),
                    child: Text(
                      'CLOSED',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
