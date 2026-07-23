import 'package:flutter/material.dart';
import 'package:signallens/widgets/sl_text.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

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

// Service to manage Wi-Fi state and settings
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

// Service to manage connected Wi-Fi process and information
class ConnectedWifiService {
  static Future<String?> getConnectedSSID() async {
    PermissionStatus status = await Permission.locationWhenInUse.request();

    if (!status.isGranted) {
      print("Location permission denied. Cannot fetch SSID.");
      return null;
    }

    try {
      bool isEnabled = await WiFiForIoTPlugin.isEnabled();
      if (!isEnabled) return "Wi-Fi Disabled";

      String? ssid = await WiFiForIoTPlugin.getSSID();

      if (ssid != null && ssid.startsWith('"') && ssid.endsWith('"')) {
        ssid = ssid.substring(1, ssid.length - 1);
      }

      if (ssid == null || ssid == "<unknown ssid>") {
        return ":(";
      }

      return ssid;
    } catch (e) {
      print("Error fetching connected SSID: $e");
      return null;
    }
  }

  static Future<String?> getConnectedBSSID() async {
    return await WiFiForIoTPlugin.getBSSID();
  }

  static Future<bool> connectWifi(
    String ssid,
    String password,
    String security,
  ) async {
    try {
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
        return true;
      }
      print("Failed to connect to $ssid");
      return false;
    } catch (e) {
      print("Error fetching connected SSID: $e");
      return false;
    }
  }

  static Future<bool> disconnectWifi({String? currentSsid}) async {
    try {
      bool isDisconnected = await WiFiForIoTPlugin.disconnect();

      if (currentSsid != null && currentSsid.isNotEmpty) {
        await WiFiForIoTPlugin.removeWifiNetwork(currentSsid);
      }

      await WiFiForIoTPlugin.forceWifiUsage(false);

      return isDisconnected;
    } catch (e) {
      print("Error disconnecting from Wi-Fi: $e");
      return false;
    }
  }
}

// Function to scan available Wi-Fi networks
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
