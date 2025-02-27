import 'dart:typed_data';

class AppData {
  final String name;
  final int score;
  final String packageName;
  final Uint8List? iconBytes;

  AppData(this.name, this.score, this.packageName, this.iconBytes);
}