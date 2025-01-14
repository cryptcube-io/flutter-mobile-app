import 'package:wifi_scan/wifi_scan.dart';

class WifiScanner {
  static final WifiScanner _instance = WifiScanner._internal();
  factory WifiScanner() => _instance;
  WifiScanner._internal();

  Future<void> scanWifiNetworks() async {
    final can = await WiFiScan.instance.canStartScan();
    if (can != CanStartScan.yes) {
      print("Cannot scan for wifi networks");
      return;
    }

    final result = await WiFiScan.instance.startScan();
    if (result) {
      await Future.delayed(Duration(seconds: 2));
      final results = await WiFiScan.instance.getScannedResults();

      for (var network in results) {
        print("Network SSID: ${network.ssid}");
        print("Signal Strength: ${network.level} dBm");
        print("-----------------");
      }
    }
  }
}
