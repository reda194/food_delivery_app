import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String? iconUrl;
  final int restaurantCount;
  final bool isPopular;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.iconUrl,
    required this.restaurantCount,
    this.isPopular = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        iconUrl,
        restaurantCount,
        isPopular,
      ];
}
