import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_featured_restaurants_usecase.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

/// Home Bloc - Manages state for the home screen
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetFeaturedRestaurantsUseCase getFeaturedRestaurantsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final HomeRepository repository;

  HomeBloc({
    required this.getFeaturedRestaurantsUseCase,
    required this.getCategoriesUseCase,
    required this.repository,
  }) : super(const HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<RefreshHomeDataEvent>(_onRefreshHomeData);
    on<SelectCategoryEvent>(_onSelectCategory);
    on<SearchRestaurantsEvent>(_onSearchRestaurants);
    on<ClearSearchEvent>(_onClearSearch);
  }

  /// Load all home screen data
  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    // Load featured restaurants and categories in parallel
    final restaurantsResult = await getFeaturedRestaurantsUseCase();
    final categoriesResult = await getCategoriesUseCase();

    // Check if both succeeded
    if (restaurantsResult.isLeft() || categoriesResult.isLeft()) {
      final error = restaurantsResult.fold(
        (failure) => failure.message,
        (_) => categoriesResult.fold(
          (failure) => failure.message,
          (_) => 'Unknown error',
        ),
      );
      emit(HomeError(error));
      return;
    }

    // Extract data
    final restaurants = restaurantsResult.getOrElse(() => []);
    final categories = categoriesResult.getOrElse(() => []);

    emit(HomeLoaded(
      featuredRestaurants: restaurants,
      categories: categories,
      displayedRestaurants: restaurants,
    ));
  }

  /// Refresh home screen data
  Future<void> _onRefreshHomeData(
    RefreshHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      emit(HomeRefreshing(state as HomeLoaded));
    }

    // Reload data
    final restaurantsResult = await getFeaturedRestaurantsUseCase();
    final categoriesResult = await getCategoriesUseCase();

    if (restaurantsResult.isLeft() || categoriesResult.isLeft()) {
      // Restore previous state on error
      if (state is HomeRefreshing) {
        emit((state as HomeRefreshing).previousState);
      }
      return;
    }

    final restaurants = restaurantsResult.getOrElse(() => []);
    final categories = categoriesResult.getOrElse(() => []);

    emit(HomeLoaded(
      featuredRestaurants: restaurants,
      categories: categories,
      displayedRestaurants: restaurants,
    ));
  }

  /// Filter restaurants by category
  Future<void> _onSelectCategory(
    SelectCategoryEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;

    // If null, show all featured restaurants
    if (event.categoryId == null) {
      emit(currentState.copyWith(
        displayedRestaurants: currentState.featuredRestaurants,
        selectedCategoryId: null,
      ));
      return;
    }

    emit(const HomeLoading());

    // Fetch restaurants by category
    final result = await repository.getRestaurantsByCategory(event.categoryId!);

    result.fold(
      (failure) {
        emit(HomeError(failure.message));
        // Restore previous state after showing error
        emit(currentState);
      },
      (restaurants) {
        emit(currentState.copyWith(
          displayedRestaurants: restaurants,
          selectedCategoryId: event.categoryId,
        ));
      },
    );
  }

  /// Search restaurants
  Future<void> _onSearchRestaurants(
    SearchRestaurantsEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;

    if (event.query.trim().isEmpty) {
      // Clear search
      emit(currentState.copyWith(
        displayedRestaurants: currentState.featuredRestaurants,
        isSearching: false,
        searchQuery: null,
      ));
      return;
    }

    emit(currentState.copyWith(isSearching: true));

    final result = await repository.searchRestaurants(event.query);

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (restaurants) {
        emit(currentState.copyWith(
          displayedRestaurants: restaurants,
          isSearching: false,
          searchQuery: event.query,
        ));
      },
    );
  }

  /// Clear search results
  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;

    emit(currentState.copyWith(
      displayedRestaurants: currentState.featuredRestaurants,
      isSearching: false,
      searchQuery: null,
      selectedCategoryId: null,
    ));
  }
}
