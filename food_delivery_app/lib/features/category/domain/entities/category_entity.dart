import 'package:equatable/equatable.dart';

/// Category Entity - Domain layer representation
/// Represents a food category (e.g., Burgers, Pizza, Desserts)
class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final int itemCount;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.itemCount,
    this.isActive = true,
    this.sortOrder = 0,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        itemCount,
        isActive,
        sortOrder,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'CategoryEntity(id: $id, name: $name, itemCount: $itemCount)';
  }

  /// Create a copy with updated fields
  CategoryEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? itemCount,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      itemCount: itemCount ?? this.itemCount,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
