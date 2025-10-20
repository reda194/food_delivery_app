import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

/// Order Model - Data transfer object with JSON serialization
@JsonSerializable()
class OrderModel {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double tax;
  final double total;
  final String addressId;
  final String addressText;
  final String paymentMethodId;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;
  final DateTime? estimatedDeliveryTime;
  final String? specialInstructions;
  final String? promoCode;

  const OrderModel({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.tax,
    required this.total,
    required this.addressId,
    required this.addressText,
    required this.paymentMethodId,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.estimatedDeliveryTime,
    this.specialInstructions,
    this.promoCode,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
