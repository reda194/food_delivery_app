import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/category_entity.dart';

/// Category Chip List - Horizontal scrollable list of category chips
class CategoryChipList extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final Function(String?) onCategorySelected;

  const CategoryChipList({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
        ),
        itemCount: categories.length + 1, // +1 for "All" chip
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All" chip
            return _buildCategoryChip(
              label: 'All',
              isSelected: selectedCategoryId == null,
              onTap: () => onCategorySelected(null),
            );
          }

          final category = categories[index - 1];
          return _buildCategoryChip(
            label: category.name,
            isSelected: selectedCategoryId == category.id,
            onTap: () => onCategorySelected(category.id),
            count: category.restaurantCount,
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    int? count,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: AppDimensions.space8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: AppDimensions.space4),
              Text(
                '($count)',
                style: AppTextStyles.labelSmall.copyWith(
                  color: isSelected
                      ? AppColors.textOnPrimary.withOpacity(0.8)
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.primary,
        checkmarkColor: AppColors.textOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.chipRadius),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space12,
          vertical: AppDimensions.space8,
        ),
      ),
    );
  }
}
