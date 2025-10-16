import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/payment_method_entity.dart';

part 'payment_method_model.g.dart';

/// Payment Method Model - Data transfer object with JSON serialization
@JsonSerializable()
class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.id,
    required super.type,
    required super.name,
    super.cardNumber,
    super.cardBrand,
    super.expiryDate,
    super.isDefault,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodModelToJson(this);

  factory PaymentMethodModel.fromEntity(PaymentMethodEntity entity) {
    return PaymentMethodModel(
      id: entity.id,
      type: entity.type,
      name: entity.name,
      cardNumber: entity.cardNumber,
      cardBrand: entity.cardBrand,
      expiryDate: entity.expiryDate,
      isDefault: entity.isDefault,
    );
  }
}
