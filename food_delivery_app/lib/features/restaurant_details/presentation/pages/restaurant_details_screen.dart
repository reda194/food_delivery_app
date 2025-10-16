import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/route_names.dart';
import '../bloc/restaurant_details_bloc.dart';
import '../bloc/restaurant_details_event.dart';
import '../bloc/restaurant_details_state.dart';
import '../widgets/restaurant_header.dart';
import '../widgets/restaurant_info_card.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/review_card.dart';

/// Restaurant Details Screen - Displays detailed restaurant information
class RestaurantDetailsScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<RestaurantDetailsScreen> createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<RestaurantDetailsBloc>().state;
      if (state is RestaurantDetailsLoaded && !state.isLoadingMoreReviews) {
        context.read<RestaurantDetailsBloc>().add(
              LoadMoreReviewsEvent(
                widget.restaurantId,
                state.currentReviewPage + 1,
              ),
            );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<RestaurantDetailsBloc, RestaurantDetailsState>(
        listener: (context, state) {
          if (state is RestaurantDetailsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is RestaurantDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RestaurantDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: AppDimensions.space16),
                  const Text(
                    'Failed to load restaurant',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Text(
                    state.message,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.space24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RestaurantDetailsBloc>().add(
                            LoadRestaurantDetailsEvent(widget.restaurantId),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is RestaurantDetailsLoaded || state is RestaurantDetailsRefreshing) {
            final restaurant = state is RestaurantDetailsLoaded
                ? state.restaurant
                : (state as RestaurantDetailsRefreshing).restaurant;
            final menuItems = state is RestaurantDetailsLoaded
                ? state.menuItems
                : (state as RestaurantDetailsRefreshing).menuItems;
            final reviews = state is RestaurantDetailsLoaded
                ? state.reviews
                : (state as RestaurantDetailsRefreshing).reviews;
            final isFavorite = state is RestaurantDetailsLoaded ? state.isFavorite : false;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<RestaurantDetailsBloc>().add(
                      RefreshRestaurantDetailsEvent(widget.restaurantId),
                    );
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Restaurant Header with Image
                  RestaurantHeader(
                    restaurant: restaurant,
                    isFavorite: isFavorite,
                    onFavoriteTap: () {
                      context.read<RestaurantDetailsBloc>().add(
                            ToggleFavoriteEvent(widget.restaurantId),
                          );
                    },
                    onBackTap: () => Navigator.of(context).pop(),
                  ),

                  // Restaurant Info Card
                  SliverToBoxAdapter(
                    child: RestaurantInfoCard(restaurant: restaurant),
                  ),

                  // Menu Categories Tabs
                  if (restaurant.menuCategories.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _buildCategoryTabs(context, restaurant, state),
                    ),

                  // Menu Section
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.screenPadding),
                      child: Text(
                        'Menu',
                        style: AppTextStyles.headlineSmall,
                      ),
                    ),
                  ),

                  // Menu Items
                  if (menuItems.isEmpty)
                    SliverToBoxAdapter(
                      child: _buildEmptyState('No menu items available'),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenPadding,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return MenuItemCard(
                              item: menuItems[index],
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.foodItemDetails,
                                  arguments: menuItems[index],
                                );
                              },
                            );
                          },
                          childCount: menuItems.length,
                        ),
                      ),
                    ),

                  // Reviews Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.screenPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reviews (${restaurant.reviewCount})',
                            style: AppTextStyles.headlineSmall,
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Navigate to all reviews
                            },
                            child: const Text('See All'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Reviews List
                  if (reviews.isEmpty)
                    SliverToBoxAdapter(
                      child: _buildEmptyState('No reviews yet'),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenPadding,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return ReviewCard(
                              review: reviews[index],
                              onHelpfulTap: () {
                                context.read<RestaurantDetailsBloc>().add(
                                      MarkReviewHelpfulEvent(reviews[index].id),
                                    );
                              },
                            );
                          },
                          childCount: reviews.length,
                        ),
                      ),
                    ),

                  // Loading More Reviews Indicator
                  if (state is RestaurantDetailsLoaded && state.isLoadingMoreReviews)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(AppDimensions.space16),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),

                  // Bottom Spacing
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCategoryTabs(
    BuildContext context,
    dynamic restaurant,
    RestaurantDetailsState state,
  ) {
    final selectedCategoryId =
        state is RestaurantDetailsLoaded ? state.selectedCategoryId : null;

    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.space16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
        ),
        itemCount: restaurant.menuCategories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All" tab
            return _buildCategoryChip(
              context: context,
              label: 'All',
              isSelected: selectedCategoryId == null,
              onTap: () {
                context.read<RestaurantDetailsBloc>().add(
                      LoadMenuItemsByCategoryEvent(widget.restaurantId, null),
                    );
              },
            );
          }

          final category = restaurant.menuCategories[index - 1];
          return _buildCategoryChip(
            context: context,
            label: '${category.name} (${category.itemCount})',
            isSelected: selectedCategoryId == category.id,
            onTap: () {
              context.read<RestaurantDetailsBloc>().add(
                    LoadMenuItemsByCategoryEvent(widget.restaurantId, category.id),
                  );
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: AppDimensions.space8),
      child: FilterChip(
        label: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
          ),
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
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.space32),
      child: Center(
        child: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}
