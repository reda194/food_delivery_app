import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/restaurant_details_entity.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/restaurant_details_repository.dart';
import '../datasources/restaurant_details_remote_datasource.dart';

/// Restaurant Details Repository Implementation
class RestaurantDetailsRepositoryImpl implements RestaurantDetailsRepository {
  final RestaurantDetailsRemoteDataSource remoteDataSource;

  RestaurantDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, RestaurantDetailsEntity>> getRestaurantDetails(
    String restaurantId,
  ) async {
    try {
      final result = await remoteDataSource.getRestaurantDetails(restaurantId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MenuItemEntity>>> getMenuItemsByCategory(
    String restaurantId,
    String categoryId,
  ) async {
    try {
      final result = await remoteDataSource.getMenuItemsByCategory(
        restaurantId,
        categoryId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MenuItemEntity>>> getAllMenuItems(
    String restaurantId,
  ) async {
    try {
      final result = await remoteDataSource.getAllMenuItems(restaurantId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviews(
    String restaurantId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final result = await remoteDataSource.getReviews(
        restaurantId,
        page: page,
        limit: limit,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> submitReview({
    required String restaurantId,
    required double rating,
    required String comment,
    List<String>? imageUrls,
  }) async {
    try {
      final result = await remoteDataSource.submitReview(
        restaurantId: restaurantId,
        rating: rating,
        comment: comment,
        imageUrls: imageUrls,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markReviewHelpful(String reviewId) async {
    try {
      await remoteDataSource.markReviewHelpful(reviewId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
