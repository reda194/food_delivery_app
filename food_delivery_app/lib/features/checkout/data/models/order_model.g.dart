// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      restaurantName: json['restaurantName'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      addressId: json['addressId'] as String,
      addressText: json['addressText'] as String,
      paymentMethodId: json['paymentMethodId'] as String,
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      estimatedDeliveryTime: json['estimatedDeliveryTime'] == null
          ? null
          : DateTime.parse(json['estimatedDeliveryTime'] as String),
      specialInstructions: json['specialInstructions'] as String?,
      promoCode: json['promoCode'] as String?,
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurantId': instance.restaurantId,
      'restaurantName': instance.restaurantName,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'deliveryFee': instance.deliveryFee,
      'discount': instance.discount,
      'tax': instance.tax,
      'total': instance.total,
      'addressId': instance.addressId,
      'addressText': instance.addressText,
      'paymentMethodId': instance.paymentMethodId,
      'paymentMethod': instance.paymentMethod,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'estimatedDeliveryTime':
          instance.estimatedDeliveryTime?.toIso8601String(),
      'specialInstructions': instance.specialInstructions,
      'promoCode': instance.promoCode,
    };
