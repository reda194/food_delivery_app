import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../home/domain/entities/restaurant_entity.dart';
import '../entities/restaurant_filter.dart';
import '../repositories/category_repository.dart';

class SearchRestaurantsInCategoryUseCase
    implements UseCase<List<RestaurantEntity>, SearchRestaurantsInCategoryParams> {
  final CategoryRepository repository;

  SearchRestaurantsInCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<RestaurantEntity>>> call(
      SearchRestaurantsInCategoryParams params) async {
    return await repository.searchRestaurantsInCategory(
      categoryId: params.categoryId,
      query: params.query,
      filter: params.filter,
    );
  }
}

class SearchRestaurantsInCategoryParams extends Equatable {
  final String categoryId;
  final String query;
  final RestaurantFilter? filter;

  const SearchRestaurantsInCategoryParams({
    required this.categoryId,
    required this.query,
    this.filter,
  });

  @override
  List<Object?> get props => [categoryId, query, filter];
}
