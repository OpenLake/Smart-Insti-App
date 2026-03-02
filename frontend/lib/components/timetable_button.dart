import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';

class TimetableButton extends StatelessWidget {
  const TimetableButton(
      {super.key, required this.child, this.onPressed, this.isHeader = false});

  final Widget child;
  final void Function()? onPressed;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 70,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isHeader
            ? UltimateTheme.primary.withValues(alpha: 0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHeader
              ? UltimateTheme.primary.withValues(alpha: 0.1)
              : UltimateTheme.primary.withValues(alpha: 0.05),
          width: 1.5,
        ),
        boxShadow: isHeader
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          splashColor: UltimateTheme.primary.withValues(alpha: 0.1),
          highlightColor: UltimateTheme.primary.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Center(
              child: DefaultTextStyle(
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
                  color:
                      isHeader ? UltimateTheme.primary : UltimateTheme.textMain,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
