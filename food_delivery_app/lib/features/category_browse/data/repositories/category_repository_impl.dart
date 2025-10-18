import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/restaurant_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/restaurant_filter.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(
      String categoryId) async {
    try {
      final category = await remoteDataSource.getCategoryById(categoryId);
      return Right(category);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurantsByCategory({
    required String categoryId,
    RestaurantFilter? filter,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final restaurants = await remoteDataSource.getRestaurantsByCategory(
        categoryId: categoryId,
        filter: filter,
        limit: limit,
        offset: offset,
      );
      return Right(restaurants);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RestaurantEntity>>> searchRestaurantsInCategory({
    required String categoryId,
    required String query,
    RestaurantFilter? filter,
  }) async {
    try {
      final restaurants = await remoteDataSource.searchRestaurantsInCategory(
        categoryId: categoryId,
        query: query,
        filter: filter,
      );
      return Right(restaurants);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
