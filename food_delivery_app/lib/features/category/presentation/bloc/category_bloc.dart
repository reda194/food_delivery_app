import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/services/logger_service.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

/// Category BLoC
/// Manages category-related state and business logic
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetActiveCategoriesUseCase getActiveCategoriesUseCase;
  final GetCategoryByIdUseCase getCategoryByIdUseCase;
  final SearchCategoriesUseCase searchCategoriesUseCase;
  final GetCategoryItemsUseCase getCategoryItemsUseCase;
  final LoggerService _logger = LoggerService.instance;

  CategoryBloc({
    required this.getCategoriesUseCase,
    required this.getActiveCategoriesUseCase,
    required this.getCategoryByIdUseCase,
    required this.searchCategoriesUseCase,
    required this.getCategoryItemsUseCase,
  }) : super(const CategoryInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<LoadActiveCategoriesEvent>(_onLoadActiveCategories);
    on<LoadCategoryByIdEvent>(_onLoadCategoryById);
    on<SearchCategoriesEvent>(_onSearchCategories);
    on<LoadCategoryItemsEvent>(_onLoadCategoryItems);
    on<RefreshCategoriesEvent>(_onRefreshCategories);
  }

  /// Load all categories
  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      _logger.info('Loading all categories...');
      emit(const CategoryLoading());

      final result = await getCategoriesUseCase(NoParams());

      result.fold(
        (failure) {
          _logger.error('Failed to load categories: ${failure.message}');
          emit(CategoryError(failure.message));
        },
        (categories) {
          if (categories.isEmpty) {
            _logger.info('No categories found');
            emit(const CategoryEmpty('No categories available'));
          } else {
            _logger.info('Loaded ${categories.length} categories');
            emit(CategoriesLoaded(categories));
          }
        },
      );
    } catch (e, stackTrace) {
      _logger.error('Unexpected error loading categories: $e', stackTrace);
      emit(CategoryError('Failed to load categories: ${e.toString()}'));
    }
  }

  /// Load active categories only
  Future<void> _onLoadActiveCategories(
    LoadActiveCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      _logger.info('Loading active categories...');
      emit(const CategoryLoading());

      final result = await getActiveCategoriesUseCase(NoParams());

      result.fold(
        (failure) {
          _logger.error('Failed to load active categories: ${failure.message}');
          emit(CategoryError(failure.message));
        },
        (categories) {
          if (categories.isEmpty) {
            _logger.info('No active categories found');
            emit(const CategoryEmpty('No active categories available'));
          } else {
            _logger.info('Loaded ${categories.length} active categories');
            emit(CategoriesLoaded(categories));
          }
        },
      );
    } catch (e, stackTrace) {
      _logger.error('Unexpected error loading active categories: $e', stackTrace);
      emit(CategoryError('Failed to load active categories: ${e.toString()}'));
    }
  }

  /// Load category by ID
  Future<void> _onLoadCategoryById(
    LoadCategoryByIdEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      _logger.info('Loading category by ID: ${event.categoryId}');
      emit(const CategoryLoading());

      final result = await getCategoryByIdUseCase(event.categoryId);

      result.fold(
        (failure) {
          _logger.error('Failed to load category: ${failure.message}');
          emit(CategoryError(failure.message));
        },
        (category) {
          _logger.info('Successfully loaded category: ${category.name}');
          emit(CategoryLoaded(category));
        },
      );
    } catch (e, stackTrace) {
      _logger.error('Unexpected error loading category: $e', stackTrace);
      emit(CategoryError('Failed to load category: ${e.toString()}'));
    }
  }

  /// Search categories
  Future<void> _onSearchCategories(
    SearchCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      _logger.info('Searching categories with query: "${event.query}"');
      emit(const CategoryLoading());

      final result = await searchCategoriesUseCase(event.query);

      result.fold(
        (failure) {
          _logger.error('Failed to search categories: ${failure.message}');
          emit(CategoryError(failure.message));
        },
        (categories) {
          if (categories.isEmpty) {
            _logger.info('No categories found matching "${event.query}"');
            emit(CategoryEmpty('No categories found matching "${event.query}"'));
          } else {
            _logger.info('Found ${categories.length} categories matching "${event.query}"');
            emit(CategoriesLoaded(categories));
          }
        },
      );
    } catch (e, stackTrace) {
      _logger.error('Unexpected error searching categories: $e', stackTrace);
      emit(CategoryError('Failed to search categories: ${e.toString()}'));
    }
  }

  /// Load category items
  Future<void> _onLoadCategoryItems(
    LoadCategoryItemsEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      _logger.info('Loading items for category: ${event.categoryId}');
      emit(const CategoryLoading());

      final result = await getCategoryItemsUseCase(event.categoryId);

      result.fold(
        (failure) {
          _logger.error('Failed to load category items: ${failure.message}');
          emit(CategoryError(failure.message));
        },
        (items) {
          if (items.isEmpty) {
            _logger.info('No items found in category ${event.categoryId}');
            emit(const CategoryEmpty('No items available in this category'));
          } else {
            _logger.info('Loaded ${items.length} items for category ${event.categoryId}');
            emit(CategoryItemsLoaded(
              categoryId: event.categoryId,
              items: items,
            ));
          }
        },
      );
    } catch (e, stackTrace) {
      _logger.error('Unexpected error loading category items: $e', stackTrace);
      emit(CategoryError('Failed to load category items: ${e.toString()}'));
    }
  }

  /// Refresh categories
  Future<void> _onRefreshCategories(
    RefreshCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    // Reuse load categories logic
    add(const LoadCategoriesEvent());
  }
}
