import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

/// Remove from Cart Use Case
class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<Either<Failure, CartEntity>> call(String itemId) async {
    if (itemId.isEmpty) {
      return const Left(ValidationFailure('Item ID cannot be empty'));
    }

    return await repository.removeItem(itemId);
  }
}
