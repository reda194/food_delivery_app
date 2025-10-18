import 'package:equatable/equatable.dart';

/// Favorites Events
abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

/// Load Favorites Event
class LoadFavoritesEvent extends FavoritesEvent {
  const LoadFavoritesEvent();
}

/// Add to Favorites Event
class AddToFavoritesEvent extends FavoritesEvent {
  final String menuItemId;

  const AddToFavoritesEvent(this.menuItemId);

  @override
  List<Object?> get props => [menuItemId];
}

/// Remove from Favorites Event
class RemoveFromFavoritesEvent extends FavoritesEvent {
  final String favoriteId;

  const RemoveFromFavoritesEvent(this.favoriteId);

  @override
  List<Object?> get props => [favoriteId];
}

/// Clear Favorites Event
class ClearFavoritesEvent extends FavoritesEvent {
  const ClearFavoritesEvent();
}
