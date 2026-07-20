import 'package:flutter/material.dart';
import 'package:signallens/pages/sl_ar_tracker.dart';
import 'package:signallens/pages/sl_home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SignalLens',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: Color(0xff5996FF),
          surface: Color(0xffFFFCE1),
          primary: Color(0xff1B4EF5),
          secondary: Color(0xff3874FF),
          tertiary: Color(0xff080616),
        ),
      ),

      home: ARScreen(),
    );
  }
}
