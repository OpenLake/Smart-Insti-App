import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.title,
    this.icon,
    required this.onTap,
    required this.primaryColor,
    required this.secondaryColor,
    this.body,
    this.contentPadding,
  });

  final String title;
  final List<Widget>? body;
  final IconData? icon;
  final VoidCallback onTap;
  final EdgeInsets? contentPadding;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: contentPadding ?? const EdgeInsets.all(20),
        decoration: UltimateTheme.bentoDecoration(context).copyWith(
          color: isDark
              ? primaryColor.withValues(alpha: 0.05)
              : primaryColor.withValues(alpha: 0.08),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  color: primaryColor,
                  size: 32,
                ),
              ).animate().scale(
                  delay: 100.ms, duration: 400.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? UltimateTheme.darkTextMain
                    : UltimateTheme.textMain,
                height: 1.2,
              ),
            ),
            if (body != null && body!.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...body!,
            ],
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutQuad);
  }
}
