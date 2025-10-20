import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/logger_service.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';

/// Category Repository Implementation
/// Implements the domain layer contract with actual data operations
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final LoggerService _logger = LoggerService.instance;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories.map((model) => model.toEntity()).toList());
    } catch (e) {
      _logger.error('Repository error - getCategories: $e');
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(
      String categoryId) async {
    try {
      final category = await remoteDataSource.getCategoryById(categoryId);
      return Right(category.toEntity());
    } catch (e) {
      _logger.error('Repository error - getCategoryById: $e');
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getActiveCategories() async {
    try {
      final categories = await remoteDataSource.getActiveCategories();
      return Right(categories.map((model) => model.toEntity()).toList());
    } catch (e) {
      _logger.error('Repository error - getActiveCategories: $e');
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> searchCategories(
      String query) async {
    try {
      if (query.trim().isEmpty) {
        return const Left(
            ValidationFailure('Search query cannot be empty'));
      }

      final categories = await remoteDataSource.searchCategories(query);
      return Right(categories.map((model) => model.toEntity()).toList());
    } catch (e) {
      _logger.error('Repository error - searchCategories: $e');
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getCategoryItems(String categoryId) async {
    try {
      final items = await remoteDataSource.getCategoryItems(categoryId);
      return Right(items);
    } catch (e) {
      _logger.error('Repository error - getCategoryItems: $e');
      return Left(_mapExceptionToFailure(e));
    }
  }

  /// Map exceptions to domain layer failures
  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is ServerException) {
      return ServerFailure(exception.message);
    }

    if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    }

    if (exception is ValidationException) {
      return ValidationFailure(exception.message);
    }

    if (exception is TimeoutException) {
      return const NetworkFailure('Request timed out. Please try again.');
    }

    if (exception is SocketException) {
      return const NetworkFailure(
          'No internet connection. Please check your network.');
    }

    return ServerFailure('Unexpected error: ${exception.toString()}');
  }
}
