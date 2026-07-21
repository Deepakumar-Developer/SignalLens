import 'package:flutter/material.dart';
import 'package:signallens/functions/app_function.dart';
import 'package:signallens/pages/sl_main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  customStatusBar(Colors.white, Colors.white, Brightness.dark, Brightness.dark);
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xff5996FF),
          surface: Color(0xffffffff),
          primary: Color(0xff1B4EF5),
          secondary: Color(0xff3874FF),
          tertiary: Color(0xff080616),
        ),
      ),

      home: const SlMainPage(),
    );
  }
}
