import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/address_entity.dart';

part 'address_model.g.dart';

/// Address Model - Data transfer object with JSON serialization
@JsonSerializable()
class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.label,
    required super.addressLine1,
    super.addressLine2,
    required super.city,
    required super.state,
    required super.zipCode,
    required super.country,
    super.latitude,
    super.longitude,
    super.isDefault,
    super.instructions,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      label: entity.label,
      addressLine1: entity.addressLine1,
      addressLine2: entity.addressLine2,
      city: entity.city,
      state: entity.state,
      zipCode: entity.zipCode,
      country: entity.country,
      latitude: entity.latitude,
      longitude: entity.longitude,
      isDefault: entity.isDefault,
      instructions: entity.instructions,
    );
  }
}
