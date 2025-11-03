// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaleAdapter extends TypeAdapter<Sale> {
  @override
  final int typeId = 2;

  @override
  Sale read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sale()
      ..id = fields[0] as String
      ..productIds = (fields[1] as List).cast<String>()
      ..quantities = (fields[2] as List).cast<int>()
      ..prices = (fields[3] as List).cast<double>()
      ..totalAmount = fields[4] as double
      ..saleDate = fields[5] as DateTime
      ..isCredit = fields[6] as bool
      ..clientId = fields[7] as String?;
  }

  @override
  void write(BinaryWriter writer, Sale obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productIds)
      ..writeByte(2)
      ..write(obj.quantities)
      ..writeByte(3)
      ..write(obj.prices)
      ..writeByte(4)
      ..write(obj.totalAmount)
      ..writeByte(5)
      ..write(obj.saleDate)
      ..writeByte(6)
      ..write(obj.isCredit)
      ..writeByte(7)
      ..write(obj.clientId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
