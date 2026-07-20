import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';

class ARScreen extends StatefulWidget {
  const ARScreen({super.key});

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  ArCoreController? arController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ArCoreView(onArCoreViewCreated: onARCreated));
  }

  void onARCreated(ArCoreController controller) {
    arController = controller;
  }

  @override
  void dispose() {
    arController?.dispose();

    super.dispose();
  }
}
