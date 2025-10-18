import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/order_entity.dart';

part 'order_model.g.dart';

/// Order Model - Data transfer object with JSON serialization
@JsonSerializable()
class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.restaurantId,
    required super.restaurantName,
    required super.items,
    required super.subtotal,
    required super.deliveryFee,
    required super.discount,
    required super.tax,
    required super.total,
    required super.addressId,
    required super.addressText,
    required super.paymentMethodId,
    required super.paymentMethod,
    required super.status,
    required super.createdAt,
    super.estimatedDeliveryTime,
    super.specialInstructions,
    super.promoCode,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
