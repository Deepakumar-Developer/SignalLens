import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signallens/functions/app_function.dart';
import 'package:signallens/widgets/sl_button.dart';
import 'package:signallens/widgets/sl_input.dart';
import 'package:signallens/widgets/sl_text.dart';
import 'package:signallens/widgets/sl_loader.dart';

class SlHomePage extends StatefulWidget {
  const SlHomePage({super.key});

  @override
  State<SlHomePage> createState() => _SlHomePageState();
}

class _SlHomePageState extends State<SlHomePage> {
  bool _isWifiOn = false, isLoading = false;
  List<Map<String, dynamic>> _wifiList = [];

  Future<bool> requestPermissions() async {
    var location = await Permission.location.request();

    if (await Permission.nearbyWifiDevices.isDenied) {
      await Permission.nearbyWifiDevices.request();
    }

    return location.isGranted;
  }

  Future<void> appPermission() async {
    setState(() {
      isLoading = true;
    });
    bool ok = await requestPermissions();
    if (ok) {
      final wifiList = await scanWifi();
      setState(() {
        _wifiList = wifiList;
        isLoading = false;
      });
    }
  }

  Future<void> _checkStatus() async {
    bool enabled = await WifiManagerService.isWifiEnabled();
    setState(() {
      _isWifiOn = enabled;
    });
  }

  Future<void> _toggleWifi(bool value) async {
    bool success = await WifiManagerService.setWifiEnabled(value);

    if (!success) {
      await WifiManagerService.openWifiSettings();
    }

    await _checkStatus();
  }

  Future<void> _openWifi(bool value) async {
    await WifiManagerService.openWifiSettings();
    await _checkStatus();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appPermission();
    _checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: getScreenWidth(context),
          height: getScreenHeight(context),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 24.0,
                ),
                child: Column(
                  spacing: 24,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "lib/assets/icons/appIcon.png",
                          width: 150,
                          height: 150,
                        ),
                        SlTitleText("SignalLens", fontSize: 30),
                        SlSubtitleText(
                          "AR-Based Wireless Access Point Localization and Signal Visualization System",
                          fontSize: 12,
                          textAlign: TextAlign.center,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ],
                    ),
                    _isWifiOn
                        ? SlIconButton(
                            icon: Icons.wifi_rounded,
                            onPressed: () {
                              _toggleWifi(false);
                            },
                            tooltip: "Turn Off Wi-Fi",
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            iconColor: Theme.of(context).colorScheme.surface,
                          )
                        : SlIconButton(
                            icon: Icons.wifi_off_rounded,
                            onPressed: () {
                              _toggleWifi(true);
                            },
                            tooltip: "Turn On Wi-Fi",
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            iconColor: Theme.of(context).colorScheme.tertiary,
                          ),
                    Expanded(
                      child: Container(
                        width: getScreenWidth(context),
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: _wifiList.length,
                          itemBuilder: (context, index) {
                            final wifi = _wifiList[index];
                            return ListTile(
                              title: SlText(wifi['ssid'] ?? 'Unknown SSID'),
                              subtitle: SlText(
                                'BSSID: ${wifi['bssid'] ?? 'Unknown BSSID'}\n'
                                'RSSI: ${wifi['rssi'] ?? 'Unknown RSSI'}\n'
                                'Standard: ${wifi['standard'] ?? 'Unknown Standard'}\n'
                                'Security: ${wifi['security'] ?? 'Unknown Security'}\n'
                                'Frequency: ${wifi['frequency'] ?? 'Unknown Frequency'} MHz',
                                fontSize: 12,
                                isMuted: true,
                              ),
                              isThreeLine: true,
                            );
                          },
                        ),
                      ),
                    ),

                    SlButton(
                      label: 'Scan',
                      icon: Icons.search,
                      onPressed: () {
                        if (_isWifiOn) {
                          appPermission();
                        } else {
                          _openWifi(true);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Visibility(visible: isLoading, child: const SlLoader()),
            ],
          ),
        ),
      ),
    );
  }
}
