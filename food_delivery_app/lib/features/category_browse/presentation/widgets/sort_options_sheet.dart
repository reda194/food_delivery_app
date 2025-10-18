import 'package:flutter/material.dart';
import '../../domain/entities/restaurant_filter.dart';

class SortOptionsSheet extends StatelessWidget {
  final SortOption currentSort;
  final Function(SortOption) onSortSelected;

  const SortOptionsSheet({
    super.key,
    required this.currentSort,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Sort Options
          ...SortOption.values.map((option) {
            final isSelected = option == currentSort;
            return ListTile(
              onTap: () => onSortSelected(option),
              leading: Icon(
                _getIconForSort(option),
                color: isSelected ? Colors.orange : Colors.grey[600],
              ),
              title: Text(
                option.displayName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.black : Colors.grey[800],
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: Colors.orange)
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            );
          }),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  IconData _getIconForSort(SortOption option) {
    switch (option) {
      case SortOption.rating:
        return Icons.star;
      case SortOption.priceAscending:
      case SortOption.priceDescending:
        return Icons.attach_money;
      case SortOption.distance:
        return Icons.location_on;
      case SortOption.deliveryTime:
        return Icons.access_time;
      case SortOption.popularity:
        return Icons.trending_up;
    }
  }
}
