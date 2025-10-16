import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/cart_repository.dart';

/// Clear Cart Use Case
class ClearCartUseCase {
  final CartRepository repository;

  ClearCartUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.clearCart();
  }
}
