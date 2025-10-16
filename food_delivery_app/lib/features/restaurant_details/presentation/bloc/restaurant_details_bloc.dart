import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/restaurant_details_repository.dart';
import '../../domain/usecases/get_restaurant_details_usecase.dart';
import '../../domain/usecases/get_menu_items_usecase.dart';
import '../../domain/usecases/get_reviews_usecase.dart';
import 'restaurant_details_event.dart';
import 'restaurant_details_state.dart';

/// Restaurant Details Bloc - Manages restaurant details state
class RestaurantDetailsBloc extends Bloc<RestaurantDetailsEvent, RestaurantDetailsState> {
  final GetRestaurantDetailsUseCase getRestaurantDetailsUseCase;
  final GetMenuItemsUseCase getMenuItemsUseCase;
  final GetReviewsUseCase getReviewsUseCase;
  final RestaurantDetailsRepository repository;

  RestaurantDetailsBloc({
    required this.getRestaurantDetailsUseCase,
    required this.getMenuItemsUseCase,
    required this.getReviewsUseCase,
    required this.repository,
  }) : super(const RestaurantDetailsInitial()) {
    on<LoadRestaurantDetailsEvent>(_onLoadRestaurantDetails);
    on<RefreshRestaurantDetailsEvent>(_onRefreshRestaurantDetails);
    on<LoadMenuItemsByCategoryEvent>(_onLoadMenuItemsByCategory);
    on<LoadMoreReviewsEvent>(_onLoadMoreReviews);
    on<SubmitReviewEvent>(_onSubmitReview);
    on<MarkReviewHelpfulEvent>(_onMarkReviewHelpful);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadRestaurantDetails(
    LoadRestaurantDetailsEvent event,
    Emitter<RestaurantDetailsState> emit,
  ) async {
    emit(const RestaurantDetailsLoading());

    // Load restaurant details
    final restaurantResult = await getRestaurantDetailsUseCase(event.restaurantId);

    await restaurantResult.fold(
      (failure) async {
        emit(RestaurantDetailsError(failure.message));
      },
      (restaurant) async {
        // Load initial menu items (popular items from restaurant details)
        final menuItems = restaurant.popularItems;

        // Load initial reviews
        final reviewsResult = await getReviewsUseCase(
          restaurantId: event.restaurantId,
          page: 1,
          limit: 5,
        );

        reviewsResult.fold(
          (failure) {
            // Still show restaurant even if reviews fail to load
            emit(RestaurantDetailsLoaded(
              restaurant: restaurant,
              menuItems: menuItems,
              reviews: const [],
            ));
          },
          (reviews) {
            emit(RestaurantDetailsLoaded(
              restaurant: restaurant,
              menuItems: menuItems,
              reviews: reviews,
            ));
          },
        );
      },
    );
  }

  Future<void> _onRefreshRestaurantDetails(
    RefreshRestaurantDetailsEvent event,
    Emitter<RestaurantDetailsState> emit,
  ) async {
    if (state is RestaurantDetailsLoaded) {
      final currentState = state as RestaurantDetailsLoaded;
      emit(RestaurantDetailsRefreshing(
        restaurant: currentState.restaurant,
        menuItems: currentState.menuItems,
        reviews: currentState.reviews,
      ));
    }

    // Reload restaurant details
    final restaurantResult = await getRestaurantDetailsUseCase(event.restaurantId);

    await restaurantResult.fold(
      (failure) async {
        if (state is RestaurantDetailsRefreshing) {
          final currentState = state as RestaurantDetailsRefreshing;
          emit(RestaurantDetailsLoaded(
            restaurant: currentState.restaurant,
            menuItems: currentState.menuItems,
            reviews: currentState.reviews,
          ));
        }
      },
      (restaurant) async {
        final menuItems = restaurant.popularItems;

        final reviewsResult = await getReviewsUseCase(
          restaurantId: event.restaurantId,
          page: 1,
          limit: 5,
        );

        reviewsResult.fold(
          (failure) {
            emit(RestaurantDetailsLoaded(
              restaurant: restaurant,
              menuItems: menuItems,
              reviews: const [],
            ));
          },
          (reviews) {
            emit(RestaurantDetailsLoaded(
              restaurant: restaurant,
              menuItems: menuItems,
              reviews: reviews,
            ));
          },
        );
      },
    );
  }

  Future<void> _onLoadMenuItemsByCategory(
    LoadMenuItemsByCategoryEvent event,
    Emitter<RestaurantDetailsState> emit,
  ) async {
    if (state is! RestaurantDetailsLoaded) return;

    final currentState = state as RestaurantDetailsLoaded;

    final result = await getMenuItemsUseCase(
      restaurantId: event.restaurantId,
      categoryId: event.categoryId,
    );

    result.fold(
      (failure) {
        // Keep current state on error
      },
      (menuItems) {
        emit(currentState.copyWith(
          menuItems: menuItems,
          selectedCategoryId: event.categoryId,
          clearCategory: event.categoryId == null,
        ));
      },
    );
  }

  Future<void> _onLoadMoreReviews(
    LoadMoreReviewsEvent event,
    Emitter<RestaurantDetailsState> emit,
  ) async {
    if (state is! RestaurantDetailsLoaded) return;

    final currentState = state as RestaurantDetailsLoaded;

    if (currentState.isLoadingMoreReviews || !currentState.hasMoreReviews) {
      return;
    }

    emit(currentState.copyWith(isLoadingMoreReviews: true));

    final result = await getReviewsUseCase(
      restaurantId: event.restaurantId,
      page: event.page,
      limit: 10,
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isLoadingMoreReviews: false));
      },
      (newReviews) {
        final allReviews = [...currentState.reviews, ...newReviews];
        emit(currentState.copyWith(
          reviews: allReviews,
          isLoadingMoreReviews: false,
          hasMoreReviews: newReviews.length >= 10,
          currentReviewPage: event.page,
        ));
      },
    );
  }

  Future<void> _onSubmitReview(
    SubmitReviewEvent event,
    Emitter<RestaurantDetailsState> emit,
  ) async {
    emit(const SubmittingReview());

    final result = await repository.submitReview(
      restaurantId: event.restaurantId,
      rating: event.rating,
      comment: event.comment,
      imageUrls: event.imageUrls,
    );

    result.fold(
      (failure) {
        emit(ReviewSubmissionError(failure.message));
      },
      (review) {
        emit(ReviewSubmitted(review));
        // Reload restaurant details to update rating
        add(LoadRestaurantDetailsEvent(event.restaurantId));
      },
    );
  }

  Future<void> _onMarkReviewHelpful(
    MarkReviewHelpfulEvent event,
    Emitter<RestaurantDetailsState> emit,
  ) async {
    await repository.markReviewHelpful(event.reviewId);
    // Optionally update the review's helpful count in the current state
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<RestaurantDetailsState> emit,
  ) async {
    if (state is! RestaurantDetailsLoaded) return;

    final currentState = state as RestaurantDetailsLoaded;
    emit(currentState.copyWith(isFavorite: !currentState.isFavorite));

    // TODO: Call favorites repository to persist the change
  }
}
