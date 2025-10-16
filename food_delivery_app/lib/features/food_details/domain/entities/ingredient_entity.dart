import 'package:equatable/equatable.dart';

/// Ingredient Entity
class IngredientEntity extends Equatable {
  final String id;
  final String name;
  final String icon;
  final int calories;
  final String colorHex;

  const IngredientEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.calories,
    required this.colorHex,
  });

  @override
  List<Object?> get props => [id, name, icon, calories, colorHex];
}
