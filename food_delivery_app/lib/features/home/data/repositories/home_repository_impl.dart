import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

/// Home Repository Implementation - Implements the domain repository interface
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getFeaturedRestaurants() async {
    try {
      final restaurants = await remoteDataSource.getFeaturedRestaurants();
      return Right(restaurants);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurantsByCategory(
    String categoryId,
  ) async {
    try {
      final restaurants = await remoteDataSource.getRestaurantsByCategory(categoryId);
      return Right(restaurants);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double? radiusKm,
  }) async {
    try {
      final restaurants = await remoteDataSource.getNearbyRestaurants(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
      );
      return Right(restaurants);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RestaurantEntity>>> searchRestaurants(
    String query,
  ) async {
    try {
      if (query.trim().isEmpty) {
        return const Left(ValidationFailure('Search query cannot be empty'));
      }

      final restaurants = await remoteDataSource.searchRestaurants(query);
      return Right(restaurants);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
