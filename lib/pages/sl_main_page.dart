import 'package:flutter/material.dart';
import 'package:signallens/functions/app_function.dart';
import 'package:signallens/pages/sl_home_page.dart';
import 'package:signallens/widgets/sl_loader.dart';
import 'package:signallens/widgets/sl_text.dart';

class SlMainPage extends StatefulWidget {
  const SlMainPage({super.key});

  @override
  State<SlMainPage> createState() => _SlMainPageState();
}

class _SlMainPageState extends State<SlMainPage> {
  @override
  void initState() {
    super.initState();
    _goToNextPage();
  }

  void _goToNextPage() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SlHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(
              "lib/assets/icons/appIcon.png",
              width: 250,
              height: 250,
            ),
            Spacer(),
            SlTitleText("SignalLens", fontSize: 28),
            SizedBox(height: 18),
            slLoader(context),
            SizedBox(height: getScreenHeight(context) * 0.1),
          ],
        ),
      ),
    );
  }
}
