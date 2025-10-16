import 'package:equatable/equatable.dart';

/// Base event class for Restaurant Details
abstract class RestaurantDetailsEvent extends Equatable {
  const RestaurantDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// Load restaurant details event
class LoadRestaurantDetailsEvent extends RestaurantDetailsEvent {
  final String restaurantId;

  const LoadRestaurantDetailsEvent(this.restaurantId);

  @override
  List<Object?> get props => [restaurantId];
}

/// Refresh restaurant details event
class RefreshRestaurantDetailsEvent extends RestaurantDetailsEvent {
  final String restaurantId;

  const RefreshRestaurantDetailsEvent(this.restaurantId);

  @override
  List<Object?> get props => [restaurantId];
}

/// Load menu items by category event
class LoadMenuItemsByCategoryEvent extends RestaurantDetailsEvent {
  final String restaurantId;
  final String? categoryId;

  const LoadMenuItemsByCategoryEvent(this.restaurantId, [this.categoryId]);

  @override
  List<Object?> get props => [restaurantId, categoryId];
}

/// Load more reviews event (pagination)
class LoadMoreReviewsEvent extends RestaurantDetailsEvent {
  final String restaurantId;
  final int page;

  const LoadMoreReviewsEvent(this.restaurantId, this.page);

  @override
  List<Object?> get props => [restaurantId, page];
}

/// Submit review event
class SubmitReviewEvent extends RestaurantDetailsEvent {
  final String restaurantId;
  final double rating;
  final String comment;
  final List<String>? imageUrls;

  const SubmitReviewEvent({
    required this.restaurantId,
    required this.rating,
    required this.comment,
    this.imageUrls,
  });

  @override
  List<Object?> get props => [restaurantId, rating, comment, imageUrls];
}

/// Mark review as helpful event
class MarkReviewHelpfulEvent extends RestaurantDetailsEvent {
  final String reviewId;

  const MarkReviewHelpfulEvent(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

/// Toggle favorite restaurant event
class ToggleFavoriteEvent extends RestaurantDetailsEvent {
  final String restaurantId;

  const ToggleFavoriteEvent(this.restaurantId);

  @override
  List<Object?> get props => [restaurantId];
}
