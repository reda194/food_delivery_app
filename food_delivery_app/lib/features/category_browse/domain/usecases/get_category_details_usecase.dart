import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoryDetailsUseCase
    implements UseCase<CategoryEntity, GetCategoryDetailsParams> {
  final CategoryRepository repository;

  GetCategoryDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, CategoryEntity>> call(
      GetCategoryDetailsParams params) async {
    return await repository.getCategoryById(params.categoryId);
  }
}

class GetCategoryDetailsParams extends Equatable {
  final String categoryId;

  const GetCategoryDetailsParams({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}
