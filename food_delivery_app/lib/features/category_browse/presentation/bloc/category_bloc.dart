import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/restaurant_filter.dart';
import '../../domain/usecases/get_category_details_usecase.dart';
import '../../domain/usecases/get_restaurants_by_category_usecase.dart';
import '../../domain/usecases/search_restaurants_in_category_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoryDetailsUseCase getCategoryDetailsUseCase;
  final GetRestaurantsByCategoryUseCase getRestaurantsByCategoryUseCase;
  final SearchRestaurantsInCategoryUseCase searchRestaurantsInCategoryUseCase;

  static const int _pageSize = 20;
  String? _currentCategoryId;

  CategoryBloc({
    required this.getCategoryDetailsUseCase,
    required this.getRestaurantsByCategoryUseCase,
    required this.searchRestaurantsInCategoryUseCase,
  }) : super(const CategoryInitial()) {
    on<LoadCategoryEvent>(_onLoadCategory);
    on<ApplyFilterEvent>(_onApplyFilter);
    on<ChangeSortOptionEvent>(_onChangeSortOption);
    on<LoadMoreRestaurantsEvent>(_onLoadMoreRestaurants);
    on<SearchRestaurantsEvent>(_onSearchRestaurants);
    on<ClearSearchEvent>(_onClearSearch);
    on<RefreshRestaurantsEvent>(_onRefreshRestaurants);
  }

  Future<void> _onLoadCategory(
    LoadCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    _currentCategoryId = event.categoryId;

    // Get category details
    final categoryResult = await getCategoryDetailsUseCase(
      GetCategoryDetailsParams(categoryId: event.categoryId),
    );

    await categoryResult.fold(
      (failure) async {
        emit(CategoryError(message: failure.message));
      },
      (category) async {
        // Get restaurants
        final filter = const RestaurantFilter();
        final restaurantsResult = await getRestaurantsByCategoryUseCase(
          GetRestaurantsByCategoryParams(
            categoryId: event.categoryId,
            filter: filter,
            limit: _pageSize,
          ),
        );

        restaurantsResult.fold(
          (failure) => emit(CategoryError(message: failure.message)),
          (restaurants) {
            emit(CategoryLoaded(
              category: category,
              restaurants: restaurants,
              currentFilter: filter,
              hasMore: restaurants.length >= _pageSize,
            ));
          },
        );
      },
    );
  }

  Future<void> _onApplyFilter(
    ApplyFilterEvent event,
    Emitter<CategoryState> emit,
  ) async {
    if (state is! CategoryLoaded || _currentCategoryId == null) return;

    final currentState = state as CategoryLoaded;

    // Show loading state
    emit(currentState.copyWith(isLoadingMore: true));

    final result = await getRestaurantsByCategoryUseCase(
      GetRestaurantsByCategoryParams(
        categoryId: _currentCategoryId!,
        filter: event.filter,
        limit: _pageSize,
      ),
    );

    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (restaurants) {
        emit(CategoryLoaded(
          category: currentState.category,
          restaurants: restaurants,
          currentFilter: event.filter,
          hasMore: restaurants.length >= _pageSize,
        ));
      },
    );
  }

  Future<void> _onChangeSortOption(
    ChangeSortOptionEvent event,
    Emitter<CategoryState> emit,
  ) async {
    if (state is! CategoryLoaded || _currentCategoryId == null) return;

    final currentState = state as CategoryLoaded;
    final newFilter = currentState.currentFilter.copyWith(
      sortOption: event.sortOption,
    );

    add(ApplyFilterEvent(filter: newFilter));
  }

  Future<void> _onLoadMoreRestaurants(
    LoadMoreRestaurantsEvent event,
    Emitter<CategoryState> emit,
  ) async {
    if (state is! CategoryLoaded || _currentCategoryId == null) return;

    final currentState = state as CategoryLoaded;

    if (!currentState.hasMore || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final result = await getRestaurantsByCategoryUseCase(
      GetRestaurantsByCategoryParams(
        categoryId: _currentCategoryId!,
        filter: currentState.currentFilter,
        limit: _pageSize,
        offset: currentState.restaurants.length,
      ),
    );

    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (newRestaurants) {
        final allRestaurants = [...currentState.restaurants, ...newRestaurants];
        emit(currentState.copyWith(
          restaurants: allRestaurants,
          hasMore: newRestaurants.length >= _pageSize,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _onSearchRestaurants(
    SearchRestaurantsEvent event,
    Emitter<CategoryState> emit,
  ) async {
    if (state is! CategoryLoaded || _currentCategoryId == null) return;

    final currentState = state as CategoryLoaded;

    if (event.query.isEmpty) {
      add(const ClearSearchEvent());
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final result = await searchRestaurantsInCategoryUseCase(
      SearchRestaurantsInCategoryParams(
        categoryId: _currentCategoryId!,
        query: event.query,
        filter: currentState.currentFilter,
      ),
    );

    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (restaurants) {
        emit(currentState.copyWith(
          restaurants: restaurants,
          searchQuery: event.query,
          hasMore: false, // No pagination for search results
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<CategoryState> emit,
  ) async {
    if (state is! CategoryLoaded || _currentCategoryId == null) return;

    final currentState = state as CategoryLoaded;

    emit(currentState.copyWith(isLoadingMore: true));

    final result = await getRestaurantsByCategoryUseCase(
      GetRestaurantsByCategoryParams(
        categoryId: _currentCategoryId!,
        filter: currentState.currentFilter,
        limit: _pageSize,
      ),
    );

    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (restaurants) {
        emit(currentState.copyWith(
          restaurants: restaurants,
          clearSearch: true,
          hasMore: restaurants.length >= _pageSize,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _onRefreshRestaurants(
    RefreshRestaurantsEvent event,
    Emitter<CategoryState> emit,
  ) async {
    if (state is! CategoryLoaded || _currentCategoryId == null) return;

    final currentState = state as CategoryLoaded;

    final result = await getRestaurantsByCategoryUseCase(
      GetRestaurantsByCategoryParams(
        categoryId: _currentCategoryId!,
        filter: currentState.currentFilter,
        limit: _pageSize,
      ),
    );

    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (restaurants) {
        emit(currentState.copyWith(
          restaurants: restaurants,
          hasMore: restaurants.length >= _pageSize,
        ));
      },
    );
  }
}
