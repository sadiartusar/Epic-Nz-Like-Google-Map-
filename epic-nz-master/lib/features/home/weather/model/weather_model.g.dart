// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherModelAdapter extends TypeAdapter<WeatherModel> {
  @override
  final int typeId = 1;

  @override
  WeatherModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherModel(
      location: fields[0] as String,
      country: fields[1] as String,
      temperature: fields[2] as double,
      description: fields[3] as String,
      humidity: fields[4] as int,
      windSpeed: fields[5] as double,
      icon: fields[6] as String,
      sunrise: fields[7] as DateTime,
      sunset: fields[8] as DateTime,
      sunriseLocal: fields[9] as String,
      sunsetLocal: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.location)
      ..writeByte(1)
      ..write(obj.country)
      ..writeByte(2)
      ..write(obj.temperature)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.humidity)
      ..writeByte(5)
      ..write(obj.windSpeed)
      ..writeByte(6)
      ..write(obj.icon)
      ..writeByte(7)
      ..write(obj.sunrise)
      ..writeByte(8)
      ..write(obj.sunset)
      ..writeByte(9)
      ..write(obj.sunriseLocal)
      ..writeByte(10)
      ..write(obj.sunsetLocal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
