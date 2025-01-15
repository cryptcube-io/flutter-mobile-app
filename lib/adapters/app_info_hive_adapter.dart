import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../models/app_info_database.dart';

@HiveType(typeId: 0)
class AppPrivacyInfoAdapter extends TypeAdapter<AppPrivacyInfo> {
  @override
  final int typeId = 0;

  @override
  AppPrivacyInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    
    try {
      return AppPrivacyInfo(
        packageName: fields[0]?.toString() ?? '',
        appName: fields[1]?.toString() ?? '',
        usageTimeInMilliseconds: fields[2] is int ? fields[2] : 0,
        installationDate: fields[3] is DateTime ? fields[3] : DateTime.now(),
        version: fields[4]?.toString() ?? '',
        operatingSystem: fields[5]?.toString() ?? '',
        privacyScore: fields[6]?.toString() ?? '',
        scoreExplanation: fields[7]?.toString() ?? '',
      );
    } catch (e) {
      print('Error reading AppPrivacyInfo: $e');
      print('Fields content: $fields');
      rethrow;
    }
  }

  @override
  void write(BinaryWriter writer, AppPrivacyInfo obj) {
    try {
      writer.writeByte(8);
      writer.writeByte(0);
      writer.write(obj.packageName);
      writer.writeByte(1);
      writer.write(obj.appName);
      writer.writeByte(2);
      writer.write(obj.usageTimeInMilliseconds);
      writer.writeByte(3);
      writer.write(obj.installationDate);
      writer.writeByte(4);
      writer.write(obj.version);
      writer.writeByte(5);
      writer.write(obj.operatingSystem);
      writer.writeByte(6);
      writer.write(obj.privacyScore);
      writer.writeByte(7);
      writer.write(obj.scoreExplanation);
    } catch (e) {
      print('Error writing AppPrivacyInfo: $e');
      print('Object content: $obj');
      rethrow;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppPrivacyInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}