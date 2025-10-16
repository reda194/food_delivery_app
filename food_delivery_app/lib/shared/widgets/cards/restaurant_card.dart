import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../features/home/domain/entities/restaurant_entity.dart';

/// Restaurant Card Widget - Reusable card for displaying restaurant information
class RestaurantCard extends StatelessWidget {
  final RestaurantEntity restaurant;
  final VoidCallback? onTap;
  final bool showDistance;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.onTap,
    this.showDistance = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image with badges
            _buildImageSection(),

            // Restaurant Info
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        // Main Image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.cardRadius),
          ),
          child: CachedNetworkImage(
            imageUrl: restaurant.imageUrl,
            height: AppDimensions.restaurantCardImageHeight,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.shimmerBase,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.borderLight,
              child: const Icon(
                Icons.restaurant,
                size: 48,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),

        // Featured Badge
        if (restaurant.isFeatured)
          Positioned(
            top: AppDimensions.space12,
            left: AppDimensions.space12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space12,
                vertical: AppDimensions.space4,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Text(
                'Featured',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
            ),
          ),

        // Closed Badge
        if (!restaurant.isOpen)
          Positioned(
            top: AppDimensions.space12,
            right: AppDimensions.space12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space12,
                vertical: AppDimensions.space4,
              ),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Text(
                'Closed',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
            ),
          ),

        // Delivery Fee Badge
        Positioned(
          bottom: AppDimensions.space12,
          right: AppDimensions.space12,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space12,
              vertical: AppDimensions.space8,
            ),
            decoration: BoxDecoration(
              color: restaurant.deliveryFee == 0
                  ? AppColors.freeDelivery
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              restaurant.deliveryFee == 0
                  ? 'Free Delivery'
                  : '\$${restaurant.deliveryFee.toStringAsFixed(2)} delivery',
              style: AppTextStyles.labelSmall.copyWith(
                color: restaurant.deliveryFee == 0
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Name
          Text(
            restaurant.name,
            style: AppTextStyles.restaurantName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: AppDimensions.space4),

          // Cuisines
          Text(
            restaurant.cuisines.join(' • '),
            style: AppTextStyles.cuisineType,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: AppDimensions.space12),

          // Rating, Time, Distance Row
          Row(
            children: [
              // Rating
              const Icon(
                Icons.star,
                size: AppDimensions.iconSM,
                color: AppColors.rating,
              ),
              const SizedBox(width: AppDimensions.space4),
              Text(
                restaurant.rating.toStringAsFixed(1),
                style: AppTextStyles.rating,
              ),
              const SizedBox(width: AppDimensions.space4),
              Text(
                '(${restaurant.reviewCount})',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),

              const SizedBox(width: AppDimensions.space16),

              // Delivery Time
              const Icon(
                Icons.access_time,
                size: AppDimensions.iconSM,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppDimensions.space4),
              Text(
                '${restaurant.deliveryTime} min',
                style: AppTextStyles.deliveryTime,
              ),

              if (showDistance && restaurant.distance != null) ...[
                const SizedBox(width: AppDimensions.space16),

                // Distance
                const Icon(
                  Icons.location_on,
                  size: AppDimensions.iconSM,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppDimensions.space4),
                Text(
                  '${restaurant.distance!.toStringAsFixed(1)} km',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
