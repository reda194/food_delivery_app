import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/add_to_favorites_usecase.dart';
import '../../domain/usecases/remove_from_favorites_usecase.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

/// Favorites Bloc
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritesUseCase getFavorites;
  final AddToFavoritesUseCase addToFavorites;
  final RemoveFromFavoritesUseCase removeFromFavorites;

  FavoritesBloc({
    required this.getFavorites,
    required this.addToFavorites,
    required this.removeFromFavorites,
  }) : super(const FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddToFavoritesEvent>(_onAddToFavorites);
    on<RemoveFromFavoritesEvent>(_onRemoveFromFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(const FavoritesLoading());

    final result = await getFavorites();

    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  Future<void> _onAddToFavorites(
    AddToFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await addToFavorites(event.menuItemId);

    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) async {
        // Reload favorites after adding
        final favoritesResult = await getFavorites();
        favoritesResult.fold(
          (failure) => emit(FavoritesError(failure.message)),
          (favorites) => emit(
            FavoritesActionSuccess('Added to favorites', favorites),
          ),
        );
      },
    );
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await removeFromFavorites(event.favoriteId);

    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) async {
        // Reload favorites after removing
        final favoritesResult = await getFavorites();
        favoritesResult.fold(
          (failure) => emit(FavoritesError(failure.message)),
          (favorites) => emit(
            FavoritesActionSuccess('Removed from favorites', favorites),
          ),
        );
      },
    );
  }
}
