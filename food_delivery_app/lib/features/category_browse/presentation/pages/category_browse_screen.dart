import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/domain/entities/restaurant_entity.dart';
import '../../domain/entities/restaurant_filter.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/sort_options_sheet.dart';

/// Category Browse Screen - Browse restaurants by category
/// Enhanced with filtering, sorting, and pagination
class CategoryBrowseScreen extends StatefulWidget {
  final String categoryId;
  final String? categoryName;

  const CategoryBrowseScreen({
    super.key,
    required this.categoryId,
    this.categoryName,
  });

  @override
  State<CategoryBrowseScreen> createState() => _CategoryBrowseScreenState();
}

class _CategoryBrowseScreenState extends State<CategoryBrowseScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategoryEvent(categoryId: widget.categoryId));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      context.read<CategoryBloc>().add(const LoadMoreRestaurantsEvent());
    }
  }

  void _showSortOptions(CategoryLoaded state) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SortOptionsSheet(
        currentSort: state.currentFilter.sortOption,
        onSortSelected: (sortOption) {
          context.read<CategoryBloc>().add(ChangeSortOptionEvent(sortOption: sortOption));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showFilterOptions(CategoryLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        currentFilter: state.currentFilter,
        onApplyFilter: (filter) {
          context.read<CategoryBloc>().add(ApplyFilterEvent(filter: filter));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (query.length >= 2) {
      context.read<CategoryBloc>().add(SearchRestaurantsEvent(query: query));
    } else if (query.isEmpty) {
      context.read<CategoryBloc>().add(const ClearSearchEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: BlocConsumer<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CategoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is! CategoryLoaded) {
              return const Center(child: Text('Unable to load category'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<CategoryBloc>().add(const RefreshRestaurantsEvent());
              },
              child: Column(
                children: [
                  // Header
                  _buildHeader(state),

                  // Search Bar
                  _buildSearchBar(),

                  // Filters and Sort
                  _buildFiltersBar(state),

                  // Restaurant List
                  Expanded(
                    child: _buildRestaurantList(state),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(CategoryLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          // Back Button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),

          const SizedBox(width: 12),

          // Category Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.category.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.restaurants.length} restaurants found',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search restaurants...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    context.read<CategoryBloc>().add(const ClearSearchEvent());
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildFiltersBar(CategoryLoaded state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          // Sort Button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showSortOptions(state),
              icon: const Icon(Icons.sort, size: 20),
              label: Text(
                state.currentFilter.sortOption.displayName,
                overflow: TextOverflow.ellipsis,
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Filter Button
          OutlinedButton.icon(
            onPressed: () => _showFilterOptions(state),
            icon: const Icon(Icons.filter_list, size: 20),
            label: const Text('Filters'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              side: BorderSide(color: Colors.grey[300]!),
              backgroundColor: _hasActiveFilters(state.currentFilter)
                  ? Colors.orange[50]
                  : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasActiveFilters(RestaurantFilter filter) {
    return filter.minRating != null ||
        filter.maxDistance != null ||
        filter.maxDeliveryTime != null ||
        filter.freeDeliveryOnly ||
        filter.openNowOnly ||
        (filter.cuisineTypes != null && filter.cuisineTypes!.isNotEmpty);
  }

  Widget _buildRestaurantList(CategoryLoaded state) {
    if (state.restaurants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              state.searchQuery != null
                  ? 'No restaurants found for "${state.searchQuery}"'
                  : 'No restaurants found',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: state.restaurants.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.restaurants.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final restaurant = state.restaurants[index];
        return RestaurantCard(
          restaurant: restaurant,
          onTap: () {
            // Navigate to restaurant details
            // Navigator.pushNamed(context, RouteNames.restaurantDetails, arguments: restaurant.id);
          },
        );
      },
    );
  }
}
