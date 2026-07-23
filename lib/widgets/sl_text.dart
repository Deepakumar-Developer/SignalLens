import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SlTitleText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final double fontSize;

  const SlTitleText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.fontSize = 22.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.spaceGrotesk(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.2,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class SlSubtitleText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final double fontSize;

  const SlSubtitleText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: color ?? Theme.of(context).colorScheme.tertiary,
      ),
    );
  }
}

class SlText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final double fontSize;
  final bool isMuted;
  final bool softWrap;
  final TextOverflow overflow;

  const SlText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.fontSize = 14.0,
    this.isMuted = false,
    this.softWrap = true,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = isMuted
        ? Colors.grey.shade600
        : Theme.of(context).colorScheme.tertiary;

    return Text(
      text,
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      style: GoogleFonts.plusJakartaSans(
        fontSize: fontSize,
        fontWeight: FontWeight.normal,
        color: color ?? defaultColor,
      ),
    );
  }
}
