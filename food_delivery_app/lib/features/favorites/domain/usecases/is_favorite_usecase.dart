import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/favorites_repository.dart';

/// Is Favorite Use Case - Check if item is favorited
class IsFavoriteUseCase {
  final FavoritesRepository repository;

  IsFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> call(String menuItemId) async {
    return await repository.isFavorite(menuItemId);
  }
}
