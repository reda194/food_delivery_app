import 'package:equatable/equatable.dart';

/// Category Entity - Food categories for filtering
class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String iconUrl;
  final int restaurantCount;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.iconUrl,
    required this.restaurantCount,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, iconUrl, restaurantCount];

  @override
  String toString() {
    return 'CategoryEntity(id: $id, name: $name)';
  }
}
