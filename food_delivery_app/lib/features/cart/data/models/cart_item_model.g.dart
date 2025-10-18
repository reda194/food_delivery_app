// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemModelAdapter extends TypeAdapter<CartItemModel> {
  @override
  final int typeId = 0;

  @override
  CartItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemModel(
      id: fields[0] as String,
      menuItemId: fields[1] as String,
      menuItemName: fields[2] as String,
      menuItemImage: fields[3] as String,
      price: fields[4] as double,
      quantity: fields[5] as int,
      restaurantId: fields[6] as String,
      restaurantName: fields[7] as String,
      selectedAddons: (fields[8] as List).cast<String>(),
      specialInstructions: fields[9] as String?,
      addedAt: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CartItemModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.menuItemId)
      ..writeByte(2)
      ..write(obj.menuItemName)
      ..writeByte(3)
      ..write(obj.menuItemImage)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.restaurantId)
      ..writeByte(7)
      ..write(obj.restaurantName)
      ..writeByte(8)
      ..write(obj.selectedAddons)
      ..writeByte(9)
      ..write(obj.specialInstructions)
      ..writeByte(10)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
