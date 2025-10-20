import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category_entity.dart';

/// Category Repository Interface - Domain layer
/// Defines the contract that data layer must implement
abstract class CategoryRepository {
  /// Get all categories
  Future<Either<Failure, List<CategoryEntity>>> getCategories();

  /// Get category by ID
  Future<Either<Failure, CategoryEntity>> getCategoryById(String categoryId);

  /// Get active categories only
  Future<Either<Failure, List<CategoryEntity>>> getActiveCategories();

  /// Search categories by name
  Future<Either<Failure, List<CategoryEntity>>> searchCategories(String query);

  /// Get items in a category
  /// Returns menu items for a specific category
  Future<Either<Failure, dynamic>> getCategoryItems(String categoryId);
}
