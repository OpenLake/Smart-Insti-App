import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/timetable_provider.dart';

class TimetableEditor extends ConsumerStatefulWidget {
  const TimetableEditor({super.key});

  @override
  ConsumerState<TimetableEditor> createState() => _TimetableEditorState();
}

class _TimetableEditorState extends ConsumerState<TimetableEditor> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    });
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ref.read(timetableProvider.notifier).addTimetable();
          if (context.mounted) {
            context.pop();
          }
        },
        backgroundColor: UltimateTheme.primary,
        child: const Icon(Icons.save_rounded, color: Colors.white),
      ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack),
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [UltimateTheme.primary.withOpacity(0.05), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(40),
          constrained: false,
          minScale: 0.5,
          maxScale: 2.5,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Consumer(
              builder: (_, ref, __) => ref.read(timetableProvider.notifier).buildTimetableTiles(context),
            ),
          ),
        ),
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
