import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/favorites_repository.dart';

/// Add to Favorites Use Case
class AddToFavoritesUseCase {
  final FavoritesRepository repository;

  AddToFavoritesUseCase(this.repository);

  Future<Either<Failure, void>> call(String menuItemId) async {
    return await repository.addToFavorites(menuItemId);
  }
}
