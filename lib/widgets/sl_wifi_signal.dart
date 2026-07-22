import 'package:flutter/material.dart';

class SlWifiSignal extends StatelessWidget {
  final String signalStrength;
  final double iconSize;
  const SlWifiSignal({
    super.key,
    required this.signalStrength,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    int rssiValue = int.tryParse(signalStrength) ?? -100;
    print(rssiValue);
    return Icon(
      getWifiIconByRssi(rssiValue),
      size: iconSize,
      color: Theme.of(context).colorScheme.tertiary,
    );
  }

  IconData getWifiIconByRssi(int rssi) {
    if (rssi >= -67) {
      return Icons.wifi_rounded;
    } else if (rssi >= -80) {
      return Icons.wifi_2_bar_rounded;
    } else if (rssi >= -90) {
      return Icons.wifi_1_bar_rounded;
    } else {
      return Icons.wifi_off_rounded;
    }
  }
}
