import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signallens/functions/app_function.dart';

class SlHomePage extends StatefulWidget {
  const SlHomePage({super.key});

  @override
  State<SlHomePage> createState() => _SlHomePageState();
}

class _SlHomePageState extends State<SlHomePage> {
  Future<bool> requestPermissions() async {
    var location = await Permission.location.request();

    if (await Permission.nearbyWifiDevices.isDenied) {
      print("Requesting nearbyWifiDevices permission");
      await Permission.nearbyWifiDevices.request();
    }

    return location.isGranted;
  }

  Future<void> app_permission() async {
    bool ok = await requestPermissions();
    if (ok) {
      print("Permission granted");
      await scanWifi();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            await scanWifi();
          },
          child: Text("Home"),
        ),
      ),
    );
  }
}
