import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/restaurant_details_entity.dart';

/// Restaurant Info Card - Displays restaurant name, rating, delivery info
class RestaurantInfoCard extends StatelessWidget {
  final RestaurantDetailsEntity restaurant;

  const RestaurantInfoCard({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppDimensions.cardRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Name
          Text(
            restaurant.name,
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: AppDimensions.space8),

          // Cuisines
          Text(
            restaurant.cuisines.join(' • '),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          // Rating and Stats Row
          Row(
            children: [
              // Rating
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space8,
                  vertical: AppDimensions.space4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.rating,
                  borderRadius: BorderRadius.circular(AppDimensions.chipRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      restaurant.rating.toStringAsFixed(1),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.space8),

              // Review Count
              Text(
                '${restaurant.reviewCount} reviews',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),

              // Delivery Time
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${restaurant.deliveryTime} min',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),

          // Delivery Info Row
          Row(
            children: [
              // Delivery Fee
              _buildInfoChip(
                icon: Icons.delivery_dining,
                label: restaurant.deliveryFee == 0
                    ? 'Free delivery'
                    : '\$${restaurant.deliveryFee.toStringAsFixed(2)} delivery',
              ),
              const SizedBox(width: AppDimensions.space12),

              // Minimum Order
              _buildInfoChip(
                icon: Icons.shopping_bag_outlined,
                label: '\$${restaurant.minimumOrder.toStringAsFixed(2)} min',
              ),
            ],
          ),

          // Opening Status
          if (restaurant.openingStatus.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.space12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: restaurant.isOpen ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 4),
                Text(
                  restaurant.openingStatus,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: restaurant.isOpen ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
          ],

          // Description
          if (restaurant.description.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.space16),
            Text(
              restaurant.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space12,
        vertical: AppDimensions.space8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.chipRadius),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
