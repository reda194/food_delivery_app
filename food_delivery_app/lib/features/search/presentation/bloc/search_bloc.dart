import 'package:bloc/bloc.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/usecases/search_items_usecase.dart';
import '../../domain/usecases/get_recent_searches_usecase.dart';
import 'search_event.dart';
import 'search_state.dart';

/// Search Bloc
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchItemsUseCase searchItemsUseCase;
  final GetRecentSearchesUseCase getRecentSearchesUseCase;
  final SearchRepository repository;

  SearchBloc({
    required this.searchItemsUseCase,
    required this.getRecentSearchesUseCase,
    required this.repository,
  }) : super(SearchInitial()) {
    on<SearchItemsEvent>(_onSearchItems);
    on<LoadRecentSearchesEvent>(_onLoadRecentSearches);
    on<ClearRecentSearchesEvent>(_onClearRecentSearches);
    on<LoadPopularSearchesEvent>(_onLoadPopularSearches);
    on<ApplySearchFilterEvent>(_onApplySearchFilter);
    on<ClearSearchQueryEvent>(_onClearSearchQuery);
  }

  Future<void> _onSearchItems(
    SearchItemsEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(const SearchLoaded(
        items: [],
        hasMore: false,
        totalCount: 0,
        currentQuery: '',
      ));
      return;
    }

    emit(SearchLoading());

    try {
      final result = await searchItemsUseCase(
        query: event.query,
        filters: event.filters,
        page: event.page,
        limit: event.limit,
      );

      emit(SearchLoaded(
        items: result.items,
        hasMore: result.hasMore,
        totalCount: result.totalCount,
        currentQuery: event.query,
        currentFilters: event.filters,
      ));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onLoadRecentSearches(
    LoadRecentSearchesEvent event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final recentSearches = await getRecentSearchesUseCase();
      emit(RecentSearchesLoaded(recentSearches));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onClearRecentSearches(
    ClearRecentSearchesEvent event,
    Emitter<SearchState> emit,
  ) async {
    try {
      await repository.clearRecentSearches();
      emit(const RecentSearchesLoaded([]));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onLoadPopularSearches(
    LoadPopularSearchesEvent event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final popularSearches = await repository.getPopularSearches();
      emit(PopularSearchesLoaded(popularSearches));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onApplySearchFilter(
    ApplySearchFilterEvent event,
    Emitter<SearchState> emit,
  ) async {
    // Get current state to extract the query
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      
      if (currentState.currentQuery.isNotEmpty) {
        // Re-search with the new filters
        add(SearchItemsEvent(
          query: currentState.currentQuery,
          filters: event.filters,
        ));
      }
    }
  }

  Future<void> _onClearSearchQuery(
    ClearSearchQueryEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchLoaded(
      items: [],
      hasMore: false,
      totalCount: 0,
      currentQuery: '',
    ));
  }
}
