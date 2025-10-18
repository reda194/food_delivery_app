import 'package:flutter/material.dart';
import '../../domain/entities/restaurant_filter.dart';

class FilterBottomSheet extends StatefulWidget {
  final RestaurantFilter currentFilter;
  final Function(RestaurantFilter) onApplyFilter;

  const FilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.onApplyFilter,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late double _minRating;
  late double _maxDistance;
  late int _maxDeliveryTime;
  late bool _freeDeliveryOnly;
  late bool _openNowOnly;

  @override
  void initState() {
    super.initState();
    _minRating = widget.currentFilter.minRating ?? 0.0;
    _maxDistance = widget.currentFilter.maxDistance ?? 10.0;
    _maxDeliveryTime = widget.currentFilter.maxDeliveryTime ?? 60;
    _freeDeliveryOnly = widget.currentFilter.freeDeliveryOnly;
    _openNowOnly = widget.currentFilter.openNowOnly;
  }

  void _applyFilters() {
    final filter = widget.currentFilter.copyWith(
      minRating: _minRating > 0 ? _minRating : null,
      maxDistance: _maxDistance < 10 ? _maxDistance : null,
      maxDeliveryTime: _maxDeliveryTime < 60 ? _maxDeliveryTime : null,
      freeDeliveryOnly: _freeDeliveryOnly,
      openNowOnly: _openNowOnly,
    );

    widget.onApplyFilter(filter);
  }

  void _clearFilters() {
    setState(() {
      _minRating = 0.0;
      _maxDistance = 10.0;
      _maxDeliveryTime = 60;
      _freeDeliveryOnly = false;
      _openNowOnly = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: _clearFilters,
                          child: const Text('Clear All'),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Minimum Rating
                const Text(
                  'Minimum Rating',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _minRating,
                        min: 0,
                        max: 5,
                        divisions: 10,
                        label: _minRating.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() => _minRating = value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        _minRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Max Distance
                const Text(
                  'Maximum Distance (km)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _maxDistance,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: _maxDistance.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() => _maxDistance = value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        _maxDistance.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Max Delivery Time
                const Text(
                  'Maximum Delivery Time (min)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _maxDeliveryTime.toDouble(),
                        min: 15,
                        max: 60,
                        divisions: 9,
                        label: '$_maxDeliveryTime min',
                        onChanged: (value) {
                          setState(() => _maxDeliveryTime = value.round());
                        },
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        '$_maxDeliveryTime',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Toggle Filters
                SwitchListTile(
                  title: const Text(
                    'Free Delivery Only',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  value: _freeDeliveryOnly,
                  onChanged: (value) {
                    setState(() => _freeDeliveryOnly = value);
                  },
                  contentPadding: EdgeInsets.zero,
                ),

                SwitchListTile(
                  title: const Text(
                    'Open Now Only',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  value: _openNowOnly,
                  onChanged: (value) {
                    setState(() => _openNowOnly = value);
                  },
                  contentPadding: EdgeInsets.zero,
                ),

                const SizedBox(height: 24),

                // Apply Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
