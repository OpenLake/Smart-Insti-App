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
  final Function onTap;
  final EdgeInsets? contentPadding;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
        child: Container(
          padding: contentPadding ?? const EdgeInsets.all(16),
          decoration: UltimateTheme.bentoDecoration.copyWith(
            color: primaryColor.withOpacity(0.08), // Slightly more noticeable tint
            border: Border.all(color: primaryColor.withOpacity(0.12), width: 1.5),
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  color: primaryColor,
                  size: 32,
                ),
              ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 16),
            Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: primaryColor.withOpacity(0.8),
                letterSpacing: 1.2,
                height: 1.1,
              ),
            ),
            if (body != null && body!.isNotEmpty) ...[
              const SizedBox(height: 6),
              ...body!,
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutQuad);
  }
}
