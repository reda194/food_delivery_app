import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/review_entity.dart';
import '../repositories/restaurant_details_repository.dart';

/// Get Reviews Use Case
class GetReviewsUseCase {
  final RestaurantDetailsRepository repository;

  GetReviewsUseCase(this.repository);

  Future<Either<Failure, List<ReviewEntity>>> call({
    required String restaurantId,
    int page = 1,
    int limit = 10,
  }) async {
    if (restaurantId.isEmpty) {
      return const Left(ValidationFailure('Restaurant ID cannot be empty'));
    }

    if (page < 1) {
      return const Left(ValidationFailure('Page number must be greater than 0'));
    }

    if (limit < 1 || limit > 50) {
      return const Left(ValidationFailure('Limit must be between 1 and 50'));
    }

    return await repository.getReviews(
      restaurantId,
      page: page,
      limit: limit,
    );
  }
}
