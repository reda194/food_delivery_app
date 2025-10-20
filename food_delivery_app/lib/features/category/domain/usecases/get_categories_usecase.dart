import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

/// Use case for getting all categories
class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) async {
    return await repository.getCategories();
  }
}

/// Use case for getting active categories only
class GetActiveCategoriesUseCase
    implements UseCase<List<CategoryEntity>, NoParams> {
  final CategoryRepository repository;

  GetActiveCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) async {
    return await repository.getActiveCategories();
  }
}

/// Use case for getting a category by ID
class GetCategoryByIdUseCase implements UseCase<CategoryEntity, String> {
  final CategoryRepository repository;

  GetCategoryByIdUseCase(this.repository);

  @override
  Future<Either<Failure, CategoryEntity>> call(String categoryId) async {
    return await repository.getCategoryById(categoryId);
  }
}

/// Use case for searching categories
class SearchCategoriesUseCase implements UseCase<List<CategoryEntity>, String> {
  final CategoryRepository repository;

  SearchCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(String query) async {
    if (query.trim().isEmpty) {
      return const Left(ValidationFailure('Search query cannot be empty'));
    }
    return await repository.searchCategories(query);
  }
}

/// Use case for getting items in a category
class GetCategoryItemsUseCase implements UseCase<dynamic, String> {
  final CategoryRepository repository;

  GetCategoryItemsUseCase(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(String categoryId) async {
    return await repository.getCategoryItems(categoryId);
  }
}
