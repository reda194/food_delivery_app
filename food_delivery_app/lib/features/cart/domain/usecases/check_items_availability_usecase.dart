import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

/// Check Items Availability Use Case
/// Verifies that all cart items are still available
class CheckItemsAvailabilityUseCase {
  final CartRepository repository;

  CheckItemsAvailabilityUseCase(this.repository);

  Future<Either<Failure, Map<String, bool>>> call() async {
    return await repository.checkItemsAvailability();
  }
}

/// Item Availability Result
class ItemAvailabilityResult {
  final String itemId;
  final String itemName;
  final bool isAvailable;
  final String? reason;

  const ItemAvailabilityResult({
    required this.itemId,
    required this.itemName,
    required this.isAvailable,
    this.reason,
  });
}
