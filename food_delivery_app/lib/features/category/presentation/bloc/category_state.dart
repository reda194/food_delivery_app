import 'package:equatable/equatable.dart';
import '../../domain/entities/category_entity.dart';

/// Category States
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

/// Loading state
class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

/// Categories loaded successfully
class CategoriesLoaded extends CategoryState {
  final List<CategoryEntity> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

/// Single category loaded successfully
class CategoryLoaded extends CategoryState {
  final CategoryEntity category;

  const CategoryLoaded(this.category);

  @override
  List<Object?> get props => [category];
}

/// Category items loaded successfully
class CategoryItemsLoaded extends CategoryState {
  final String categoryId;
  final List<dynamic> items;

  const CategoryItemsLoaded({
    required this.categoryId,
    required this.items,
  });

  @override
  List<Object?> get props => [categoryId, items];
}

/// Error state
class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Empty state (no categories found)
class CategoryEmpty extends CategoryState {
  final String message;

  const CategoryEmpty(this.message);

  @override
  List<Object?> get props => [message];
}
