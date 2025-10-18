import 'package:equatable/equatable.dart';
import '../../domain/entities/favorite_item_entity.dart';

/// Favorites States
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

/// Loading State
class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

/// Loaded State
class FavoritesLoaded extends FavoritesState {
  final List<FavoriteItemEntity> favorites;

  const FavoritesLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];
}

/// Error State
class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Action Success State (for add/remove operations)
class FavoritesActionSuccess extends FavoritesState {
  final String message;
  final List<FavoriteItemEntity> favorites;

  const FavoritesActionSuccess(this.message, this.favorites);

  @override
  List<Object?> get props => [message, favorites];
}
