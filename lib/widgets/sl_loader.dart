import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:signallens/functions/app_function.dart';

Widget slLoader(BuildContext context) =>
    SpinKitFadingFour(color: Theme.of(context).colorScheme.primary, size: 50.0);

Widget slButtonLoader(BuildContext context) => SpinKitThreeBounce(
  color: Theme.of(context).colorScheme.onPrimary,
  size: 20.0,
);

class SlLoader extends StatelessWidget {
  const SlLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getScreenWidth(context),
      height: getScreenHeight(context),
      color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      child: Center(child: slLoader(context)),
    );
  }
}
