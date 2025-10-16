import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/cart_item_entity.dart';

/// Cart Item Card - Displays a cart item with quantity controls
class CartItemCard extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.space12),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.imageRadius),
              child: CachedNetworkImage(
                imageUrl: item.menuItemImage,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80,
                  height: 80,
                  color: AppColors.surfaceVariant,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 80,
                  color: AppColors.surfaceVariant,
                  child: const Icon(
                    Icons.restaurant_menu,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.space12),

            // Item Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Remove Button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.menuItemName,
                          style: AppTextStyles.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.error,
                          size: AppDimensions.iconSM,
                        ),
                        onPressed: onRemove,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Price
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: AppTextStyles.priceMedium,
                  ),

                  // Special Instructions
                  if (item.specialInstructions != null &&
                      item.specialInstructions!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Note: ${item.specialInstructions}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: AppDimensions.space12),

                  // Quantity Controls and Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity Controls
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.border,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.chipRadius,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Decrement Button
                            InkWell(
                              onTap: onDecrement,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(AppDimensions.chipRadius),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  item.quantity == 1
                                      ? Icons.delete_outline
                                      : Icons.remove,
                                  size: 20,
                                  color: item.quantity == 1
                                      ? AppColors.error
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),

                            // Quantity
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                item.quantity.toString(),
                                style: AppTextStyles.titleMedium,
                              ),
                            ),

                            // Increment Button
                            InkWell(
                              onTap: onIncrement,
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(AppDimensions.chipRadius),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.add,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Total Price
                      Text(
                        '\$${item.totalPrice.toStringAsFixed(2)}',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
