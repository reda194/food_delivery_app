import 'package:equatable/equatable.dart';
import '../../domain/entities/restaurant_details_entity.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../../domain/entities/review_entity.dart';

/// Base state class for Restaurant Details
abstract class RestaurantDetailsState extends Equatable {
  const RestaurantDetailsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class RestaurantDetailsInitial extends RestaurantDetailsState {
  const RestaurantDetailsInitial();
}

/// Loading state
class RestaurantDetailsLoading extends RestaurantDetailsState {
  const RestaurantDetailsLoading();
}

/// Loaded state with data
class RestaurantDetailsLoaded extends RestaurantDetailsState {
  final RestaurantDetailsEntity restaurant;
  final List<MenuItemEntity> menuItems;
  final List<ReviewEntity> reviews;
  final String? selectedCategoryId;
  final bool isLoadingMoreReviews;
  final bool hasMoreReviews;
  final int currentReviewPage;
  final bool isFavorite;

  const RestaurantDetailsLoaded({
    required this.restaurant,
    this.menuItems = const [],
    this.reviews = const [],
    this.selectedCategoryId,
    this.isLoadingMoreReviews = false,
    this.hasMoreReviews = true,
    this.currentReviewPage = 1,
    this.isFavorite = false,
  });

  RestaurantDetailsLoaded copyWith({
    RestaurantDetailsEntity? restaurant,
    List<MenuItemEntity>? menuItems,
    List<ReviewEntity>? reviews,
    String? selectedCategoryId,
    bool? isLoadingMoreReviews,
    bool? hasMoreReviews,
    int? currentReviewPage,
    bool? isFavorite,
    bool clearCategory = false,
  }) {
    return RestaurantDetailsLoaded(
      restaurant: restaurant ?? this.restaurant,
      menuItems: menuItems ?? this.menuItems,
      reviews: reviews ?? this.reviews,
      selectedCategoryId: clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      isLoadingMoreReviews: isLoadingMoreReviews ?? this.isLoadingMoreReviews,
      hasMoreReviews: hasMoreReviews ?? this.hasMoreReviews,
      currentReviewPage: currentReviewPage ?? this.currentReviewPage,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        restaurant,
        menuItems,
        reviews,
        selectedCategoryId,
        isLoadingMoreReviews,
        hasMoreReviews,
        currentReviewPage,
        isFavorite,
      ];
}

/// Refreshing state (used for pull-to-refresh)
class RestaurantDetailsRefreshing extends RestaurantDetailsState {
  final RestaurantDetailsEntity restaurant;
  final List<MenuItemEntity> menuItems;
  final List<ReviewEntity> reviews;

  const RestaurantDetailsRefreshing({
    required this.restaurant,
    this.menuItems = const [],
    this.reviews = const [],
  });

  @override
  List<Object?> get props => [restaurant, menuItems, reviews];
}

/// Error state
class RestaurantDetailsError extends RestaurantDetailsState {
  final String message;

  const RestaurantDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Review submission states
class SubmittingReview extends RestaurantDetailsState {
  const SubmittingReview();
}

class ReviewSubmitted extends RestaurantDetailsState {
  final ReviewEntity review;

  const ReviewSubmitted(this.review);

  @override
  List<Object?> get props => [review];
}

class ReviewSubmissionError extends RestaurantDetailsState {
  final String message;

  const ReviewSubmissionError(this.message);

  @override
  List<Object?> get props => [message];
}
