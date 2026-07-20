import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SlText extends StatelessWidget {
  final String str;
  final double fontSize;
  final bool isBold;
  const SlText(
    this.str, {
    super.key,
    required this.fontSize,
    required this.isBold,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      str,
      style: GoogleFonts.roboto(
        fontSize: fontSize,
        color: Theme.of(context).colorScheme.tertiary,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
