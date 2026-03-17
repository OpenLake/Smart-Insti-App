import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/timetable_provider.dart';

class TimetableEditor extends ConsumerStatefulWidget {
  const TimetableEditor({super.key});

  @override
  ConsumerState<TimetableEditor> createState() => _TimetableEditorState();
}

class _TimetableEditorState extends ConsumerState<TimetableEditor> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: UltimateTheme.background,
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await ref.read(timetableProvider.notifier).addTimetable();
          if (context.mounted) {
            context.pop();
          }
        },
        backgroundColor: UltimateTheme.primary,
        elevation: 6,
        icon: const Icon(Icons.save_rounded, color: Colors.white),
        label: Text("Save Schedule",
            style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold, color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ).animate().scale(delay: 600.ms, curve: Curves.easeOutBack),
      body: Stack(
        children: [
          // Background Decoration
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: UltimateTheme.background,
              gradient: LinearGradient(
                colors: [
                  UltimateTheme.primary.withValues(alpha: 0.05),
                  UltimateTheme.background,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Editor Content
          Positioned.fill(
            top: 20,
            child: InteractiveViewer(
              boundaryMargin:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
              constrained: false,
              minScale: 0.5,
              maxScale: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Consumer(
                  builder: (_, ref, __) => ref
                      .read(timetableProvider.notifier)
                      .buildTimetableTiles(context),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 400.ms),

          // Landscape Tip (Only visible if small width)
          if (width < 500)
            Positioned(
              bottom: 20,
              left: 24,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.screen_rotation_rounded,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text("Rotate for better view",
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )
                .animate(
                    onPlay: (controller) => controller.repeat(reverse: true))
                .fadeIn()
                .moveX(begin: 0, end: 5),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
