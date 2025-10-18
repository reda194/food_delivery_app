import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/favorite_item_entity.dart';

/// Favorites Repository - Abstract repository interface
abstract class FavoritesRepository {
  /// Get all favorite items
  Future<Either<Failure, List<FavoriteItemEntity>>> getFavorites();

  /// Add item to favorites
  Future<Either<Failure, void>> addToFavorites(String menuItemId);

  /// Remove item from favorites
  Future<Either<Failure, void>> removeFromFavorites(String favoriteId);

  /// Check if item is in favorites
  Future<Either<Failure, bool>> isFavorite(String menuItemId);

  /// Clear all favorites
  Future<Either<Failure, void>> clearFavorites();
}
