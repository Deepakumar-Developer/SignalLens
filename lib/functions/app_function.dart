import 'package:wifi_scan/wifi_scan.dart';

Future<void> scanWifi() async {
  // Check whether scanning is supported
  if ((await WiFiScan.instance.canStartScan()) != CanStartScan.yes) {
    print("WiFi Scan not supported");
    return;
  }

  // Start scanning
  await WiFiScan.instance.startScan();

  // Read results
  List<WiFiAccessPoint> results = await WiFiScan.instance.getScannedResults();

  for (var ap in results) {
    print("--------------------------------");

    print("SSID      : ${ap.ssid}");
    print("BSSID     : ${ap.bssid}");
    print("RSSI      : ${ap.level} dBm");
    print("Frequency : ${ap.frequency} MHz");

    print("--------------------------------");
  }
}
