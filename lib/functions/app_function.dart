import 'package:flutter/material.dart';
import 'package:signallens/widgets/sl_text.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:flutter/services.dart';
import 'package:wifi_iot/wifi_iot.dart';

double getScreenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

double getScreenHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

void customStatusBar(
  Color statusBarColor,
  Color systemNavigationBarColor,
  Brightness statusBarIconBrightness,
  Brightness systemNavigationBarIconBrightness,
) {
  print('Custom Status Bar Applied');
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: statusBarIconBrightness,
      systemNavigationBarColor: systemNavigationBarColor,
      systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
    ),
  );
}

void msg(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: SlText(text, fontSize: 12, textAlign: .left),
      padding: EdgeInsets.all(16),
      backgroundColor: Theme.of(context).colorScheme.surface,
    ),
  );
}

class WifiManagerService {
  static Future<bool> isWifiEnabled() async {
    try {
      return await WiFiForIoTPlugin.isEnabled();
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setWifiEnabled(bool enable) async {
    try {
      await WiFiForIoTPlugin.setEnabled(enable);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> openWifiSettings() async {
    await WiFiForIoTPlugin.setEnabled(true, shouldOpenSettings: true);
  }
}

Future<List<Map<String, dynamic>>> scanWifi() async {
  List<Map<String, dynamic>> wifiList = [];
  if ((await WiFiScan.instance.canStartScan()) != CanStartScan.yes) {
    print("WiFi Scan not supported");
    return wifiList;
  }

  // Start scanning
  await WiFiScan.instance.startScan();

  // Read results
  List<WiFiAccessPoint> results = await WiFiScan.instance.getScannedResults();

  for (var ap in results) {
    wifiList.add({
      "ssid": ap.ssid,
      "bssid": ap.bssid,
      "rssi": ap.level,
      "standard": ap.standard,
      "security": ap.capabilities,
      "frequency": ap.frequency,
    });
  }

  return wifiList;
}

Future<void> connectToAP(String ssid, String password, String security) async {
  NetworkSecurity securityType = security.contains("WPA")
      ? NetworkSecurity.WPA
      : NetworkSecurity.NONE;

  bool success = await WiFiForIoTPlugin.connect(
    ssid,
    password: password,
    security: securityType,
  );

  if (success) {
    print("Connected to $ssid successfully!");
  } else {
    print("Failed to connect to $ssid");
  }
}
