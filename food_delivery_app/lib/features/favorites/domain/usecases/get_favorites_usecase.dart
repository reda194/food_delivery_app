import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/favorite_item_entity.dart';
import '../repositories/favorites_repository.dart';

/// Get Favorites Use Case
class GetFavoritesUseCase {
  final FavoritesRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<Either<Failure, List<FavoriteItemEntity>>> call() async {
    return await repository.getFavorites();
  }
}
