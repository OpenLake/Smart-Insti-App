import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/ultimate_theme.dart';

class BorderlessButton extends StatelessWidget {
  const BorderlessButton({
    super.key,
    required this.backgroundColor,
    required this.onPressed,
    required this.splashColor,
    required this.label,
  });

  final Color backgroundColor;
  final Color splashColor;
  final VoidCallback onPressed;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: splashColor,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: DefaultTextStyle.merge(
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        child: label,
      ),
    );
  }
}
