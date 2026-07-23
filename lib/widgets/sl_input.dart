import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SlInput extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isRequired;
  final TextEditingController? controller;

  const SlInput({
    super.key,
    required this.label,
    required this.hintText,
    this.isRequired = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.plusJakartaSans(
                color: Colors.grey.shade400,
                fontSize: 15,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              fillColor: Theme.of(context).colorScheme.surface,
              filled: true,
            ),
          ),
        ),
      ],
    );
  }
}
