import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_insti_app/models/event.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class FeaturedHeroCard extends StatelessWidget {
  final Event? event;
  final VoidCallback? onTap;

  const FeaturedHeroCard({super.key, this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [UltimateTheme.skeletonGrey, UltimateTheme.background],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: UltimateTheme.primary.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: UltimateTheme.skeletonRed, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          event?.category.toUpperCase() ?? "FEATURED",
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: UltimateTheme.skeletonRed,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        event?.title ?? "Explore Your Campus Hub",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: UltimateTheme.textMain,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event != null
                            ? DateFormat('MMM dd, hh:mm a')
                                .format(event!.startTime)
                            : "Stay updated with latest events and activities",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: UltimateTheme.textMain.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: (event != null
                            ? UltimateTheme.skeletonBrown
                            : UltimateTheme.primary)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Icon(
                      event != null
                          ? Icons.event_available_rounded
                          : Icons.auto_awesome_rounded,
                      size: 40,
                      color: event != null
                          ? UltimateTheme.skeletonBrown
                          : UltimateTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 6),
                      width: index == 0 ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: index == 0
                            ? UltimateTheme.primary
                            : UltimateTheme.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                Text(
                  "View Details",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: UltimateTheme.accent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
