// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      userId: json['user_id'] as String,
      restaurantId: json['restaurant_id'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'] as String,
      deliveryAddress: json['delivery_address'] as String?,
      estimatedDeliveryTime:
          DateTime.parse(json['estimated_delivery_time'] as String),
      driverId: json['driver_id'] as String?,
      driverName: json['driver_name'] as String?,
      driverPhone: json['driver_phone'] as String?,
      driverImage: json['driver_image'] as String?,
      paymentMethod: json['payment_method'] as String?,
      paymentStatus: json['payment_status'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'user_id': instance.userId,
      'restaurant_id': instance.restaurantId,
      'total_amount': instance.totalAmount,
      'status': instance.status,
      'delivery_address': instance.deliveryAddress,
      'estimated_delivery_time':
          instance.estimatedDeliveryTime.toIso8601String(),
      'driver_id': instance.driverId,
      'driver_name': instance.driverName,
      'driver_phone': instance.driverPhone,
      'driver_image': instance.driverImage,
      'payment_method': instance.paymentMethod,
      'payment_status': instance.paymentStatus,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'items': instance.items,
    };

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    OrderItemModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      menuItemId: json['menu_item_id'] as String,
      menuItemName: json['menu_item_name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'menu_item_id': instance.menuItemId,
      'menu_item_name': instance.menuItemName,
      'quantity': instance.quantity,
      'price': instance.price,
      'subtotal': instance.subtotal,
      'notes': instance.notes,
    };
