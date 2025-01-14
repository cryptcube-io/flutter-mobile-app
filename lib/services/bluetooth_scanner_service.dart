import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScanner {
  static final BluetoothScanner _instance = BluetoothScanner._internal();
  factory BluetoothScanner() => _instance;
  BluetoothScanner._internal();

  Future<void> scanDevices() async {
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        String deviceName = r.device.name.isEmpty ? "Unknown" : r.device.name;
        print("Device Name: $deviceName");
        print("Device Address: ${r.device.id}");
        print("Signal Strength (RSSI): ${r.rssi}");
        print("-----------------");
      }
    });

    await FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
  }
}