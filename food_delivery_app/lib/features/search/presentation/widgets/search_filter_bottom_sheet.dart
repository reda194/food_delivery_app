import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Search Filter Bottom Sheet - Matches Figma design
class SearchFilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>)? onApplyFilter;

  const SearchFilterBottomSheet({
    super.key,
    this.onApplyFilter,
  });

  @override
  State<SearchFilterBottomSheet> createState() => _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  String _selectedCategory = 'All';
  String _selectedSort = 'High Price';
  RangeValues _priceRange = const RangeValues(10, 50);

  final List<Map<String, dynamic>> _categories = [
    {'id': 'all', 'name': 'All', 'icon': '', 'color': Colors.black},
    {'id': 'drink', 'name': 'Drink', 'icon': '🥤', 'color': const Color(0xFFE91E8E)},
    {'id': 'burger', 'name': 'Burger', 'icon': '🍔', 'color': const Color(0xFFFF9800)},
    {'id': 'pizza', 'name': 'Pizza', 'icon': '🍕', 'color': const Color(0xFF4CAF50)},
  ];

  final List<Map<String, dynamic>> _sortOptions = [
    {'id': 'fast_delivery', 'name': 'Fast Delivery', 'icon': '🛍️'},
    {'id': 'high_price', 'name': 'High Price', 'icon': '💸'},
  ];

  void _applyFilter() {
    if (widget.onApplyFilter != null) {
      widget.onApplyFilter!({
        'category': _selectedCategory,
        'sortBy': _selectedSort,
        'priceRange': _priceRange,
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),

          // Drag Handle
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 32),

          // Categories Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),

                // Category Chips
                SizedBox(
                  height: 56,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category['name'];

                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category['name'];
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: isSelected ? Colors.black : Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (category['icon'].isNotEmpty) ...[
                                  Text(
                                    category['icon'],
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  category['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : category['color'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Sort By Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),

                // Sort Options
                Row(
                  children: _sortOptions.map((option) {
                    final isSelected = _selectedSort == option['name'];

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: option == _sortOptions.last ? 0 : 16,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSort = option['name'];
                            });
                          },
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: isSelected ? Colors.black : Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  option['icon'],
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  option['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Price Range Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Price Range',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '\$${_priceRange.start.toInt()}-\$${_priceRange.end.toInt()}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Custom Range Slider with bars
                Stack(
                  children: [
                    // Background bars
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 24,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(10, (index) {
                          final heights = [40.0, 60.0, 50.0, 70.0, 65.0, 45.0, 55.0, 50.0, 60.0, 50.0];
                          return Container(
                            width: 20,
                            height: heights[index],
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                    ),

                    // Slider
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 2,
                        activeTrackColor: Colors.grey[400],
                        inactiveTrackColor: Colors.grey[300],
                        thumbColor: Colors.black,
                        overlayColor: Colors.black.withValues(alpha: 0.1),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 18,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 24,
                        ),
                        rangeThumbShape: const RoundRangeSliderThumbShape(
                          enabledThumbRadius: 18,
                        ),
                      ),
                      child: RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 100,
                        divisions: 20,
                        onChanged: (RangeValues values) {
                          setState(() {
                            _priceRange = values;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Apply Filter Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
            child: GestureDetector(
              onTap: _applyFilter,
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E7), // Light cream
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Center(
                  child: Text(
                    'Apply Filter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// Helper function to show the search filter bottom sheet
void showSearchFilterBottomSheet(
  BuildContext context, {
  Function(Map<String, dynamic>)? onApplyFilter,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => SearchFilterBottomSheet(
      onApplyFilter: onApplyFilter,
    ),
  );
}
