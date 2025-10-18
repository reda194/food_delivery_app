import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/favorite_item_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';

/// Favorites Repository Implementation
class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<FavoriteItemEntity>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return Right(favorites);
    } on CacheException {
      return const Left(CacheFailure());
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(String menuItemId) async {
    try {
      // For now, use mock data
      await localDataSource.addToFavorites(
        menuItemId,
        'New Item',
        'Description',
        15.99,
        'https://via.placeholder.com/150',
        'Category',
      );
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure());
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String favoriteId) async {
    try {
      await localDataSource.removeFromFavorites(favoriteId);
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure());
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String menuItemId) async {
    try {
      final isFav = await localDataSource.isFavorite(menuItemId);
      return Right(isFav);
    } on CacheException {
      return const Left(CacheFailure());
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearFavorites() async {
    try {
      await localDataSource.clearFavorites();
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure());
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}
