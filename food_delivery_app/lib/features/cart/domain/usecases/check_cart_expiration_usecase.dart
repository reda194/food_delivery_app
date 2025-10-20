import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/cart_repository.dart';

/// Check Cart Expiration Use Case
/// Checks if cart has expired and clears it if necessary
class CheckCartExpirationUseCase {
  final CartRepository repository;

  // Cart expires after 24 hours of inactivity
  static const Duration expirationDuration = Duration(hours: 24);

  CheckCartExpirationUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.checkAndClearExpiredCart(expirationDuration);
  }
}
