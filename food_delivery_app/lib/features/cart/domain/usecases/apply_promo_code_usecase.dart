import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

/// Apply Promo Code Use Case
class ApplyPromoCodeUseCase {
  final CartRepository repository;

  ApplyPromoCodeUseCase(this.repository);

  Future<Either<Failure, CartEntity>> call(String promoCode) async {
    if (promoCode.trim().isEmpty) {
      return const Left(ValidationFailure('Promo code cannot be empty'));
    }

    return await repository.applyPromoCode(promoCode.trim().toUpperCase());
  }
}
