import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../home/domain/entities/restaurant_entity.dart';
import '../entities/restaurant_filter.dart';
import '../repositories/category_repository.dart';

class GetRestaurantsByCategoryUseCase
    implements UseCase<List<RestaurantEntity>, GetRestaurantsByCategoryParams> {
  final CategoryRepository repository;

  GetRestaurantsByCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<RestaurantEntity>>> call(
      GetRestaurantsByCategoryParams params) async {
    return await repository.getRestaurantsByCategory(
      categoryId: params.categoryId,
      filter: params.filter,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetRestaurantsByCategoryParams extends Equatable {
  final String categoryId;
  final RestaurantFilter? filter;
  final int limit;
  final int offset;

  const GetRestaurantsByCategoryParams({
    required this.categoryId,
    this.filter,
    this.limit = 20,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [categoryId, filter, limit, offset];
}
