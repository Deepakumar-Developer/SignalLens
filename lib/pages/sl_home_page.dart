import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signallens/functions/app_function.dart';
import 'package:signallens/widgets/sl_button.dart';
import 'package:signallens/widgets/sl_text.dart';
import 'package:signallens/widgets/sl_loader.dart';
import 'package:signallens/widgets/sl_wifi_signal.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wifi_scan/wifi_scan.dart';

class SlHomePage extends StatefulWidget {
  const SlHomePage({super.key});

  @override
  State<SlHomePage> createState() => _SlHomePageState();
}

class _SlHomePageState extends State<SlHomePage> {
  bool _isWifiOn = false, isLoading = false;
  List<Map<String, dynamic>> _wifiList = [];
  String _ssid = ':(', _rssi = '', _security = '';

  // Stream Subscriptions
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<List<WiFiAccessPoint>>? _wifiScanSubscription;

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
    if (!enabled) {
      setState(() {
        _ssid = ':(';
        _rssi = '-100';
        _security = '';
      });
      return;
    }
    String ssid = await ConnectedWifiService.getConnectedSSID() ?? '';
    final wifiList = await scanWifi();
    setState(() {
      _ssid = ssid;
      if (_ssid.isNotEmpty) {
        for (var wifi in wifiList) {
          if (wifi['ssid'] == _ssid) {
            _security = wifi['security'] ?? 'Unknown';
            _rssi = '${wifi['rssi'] ?? 'Unknown'}';
            break;
          }
        }
      }
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
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _checkStatus();
    });

    _wifiScanSubscription = WiFiScan.instance.onScannedResultsAvailable.listen((
      results,
    ) {
      _checkStatus();
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _wifiScanSubscription?.cancel();
    super.dispose();
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "lib/assets/icons/appIcon.png",
                          width: 150,
                          height: 150,
                        ),
                        SizedBox(
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SlTitleText("SignalLens", fontSize: 30),
                              SizedBox(
                                width: getScreenWidth(context) - (150 + 48),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _isWifiOn
                                        ? SlIconButton(
                                            icon: Icons.wifi_rounded,
                                            onPressed: () {
                                              _toggleWifi(false);
                                            },
                                            tooltip: "Turn Off Wi-Fi",
                                          )
                                        : SlIconButton(
                                            icon: Icons.wifi_off_rounded,
                                            onPressed: () {
                                              _toggleWifi(true);
                                            },
                                            tooltip: "Turn On Wi-Fi",
                                            iconColor: Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                          ),
                                    SlIconButton(
                                      icon: Icons.replay_rounded,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: getScreenWidth(context),
                        height: getScreenHeight(context) - 260,
                        child: Column(
                          spacing: 12,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: _isWifiOn,
                              child: Container(
                                width: getScreenWidth(context),
                                padding: const EdgeInsets.all(28),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SlWifiSignal(
                                          signalStrength: _rssi,
                                          iconSize: 32,
                                        ),
                                        SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SlSubtitleText(
                                              _ssid,
                                              fontSize: 16,
                                              textAlign: TextAlign.left,
                                            ),
                                            SlText(
                                              _ssid != ':(' && _ssid.isNotEmpty
                                                  ? "Connected"
                                                  : "Not Connected",
                                              fontSize: 12,
                                              isMuted: true,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      _security.contains('WPA') ||
                                              _security.contains('WEP')
                                          ? Icons.lock_rounded
                                          : Icons.lock_open_rounded,
                                      size: 24,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.tertiary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SlSubtitleText(
                              "Available Networks",
                              fontSize: 16,
                              textAlign: TextAlign.left,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: SizedBox(
                                  width: getScreenWidth(context),

                                  child: ListView.builder(
                                    itemCount: _wifiList.length,
                                    itemBuilder: (context, index) {
                                      final wifi = _wifiList[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: getScreenWidth(context),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SlWifiSignal(
                                                    signalStrength: wifi['rssi']
                                                        .toString(),
                                                    iconSize: 24,
                                                  ),
                                                  SizedBox(width: 12),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SlText(
                                                        wifi['ssid'].toString(),
                                                        fontSize: 14,
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      SlText(
                                                        getSignalStatus(
                                                          wifi['rssi'] ?? -100,
                                                        ),
                                                        fontSize: 10,
                                                        isMuted: true,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Icon(
                                                wifi['security'].contains(
                                                          'WPA',
                                                        ) ||
                                                        wifi['security']
                                                            .contains('WEP')
                                                    ? Icons.lock_rounded
                                                    : Icons.lock_open_rounded,
                                                size: 18,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  String getSignalStatus(int dbm) {
    if (dbm >= -30) return 'Excellent (Full signal)';
    if (dbm >= -67) return 'Very Good';
    if (dbm >= -70) return 'Okay';
    if (dbm >= -80) return 'Not Good';
    return 'Unusable (Weak signal)';
  }
}
