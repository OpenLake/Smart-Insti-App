import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/event_provider.dart';
import '../../components/borderless_button.dart';
import '../../provider/auth_provider.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventProvider.notifier).loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventProvider);
    final currentUserRole = ref.watch(authProvider).currentUserRole;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton:
          currentUserRole == 'admin' || currentUserRole == 'faculty'
              ? FloatingActionButton.extended(
                  onPressed: () => _showAddEventDialog(context, ref),
                  backgroundColor: UltimateTheme.primary,
                  elevation: 4,
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  label: Text("Add Event",
                      style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack)
              : null,
      body: eventState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : eventState.events.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: UltimateTheme.primary.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.event_busy_rounded,
                            size: 64,
                            color:
                                UltimateTheme.primary.withValues(alpha: 0.3)),
                      ),
                      const SizedBox(height: 24),
                      Text("No upcoming events",
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: UltimateTheme.textMain)),
                      Text("Check back later for updates!",
                          style:
                              GoogleFonts.inter(color: UltimateTheme.textSub)),
                    ],
                  ).animate().fadeIn(),
                )
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final event = eventState.events[index];
                            return _buildEventTicket(event, index);
                          },
                          childCount: eventState.events.length,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildEventTicket(event, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border:
            Border.all(color: UltimateTheme.primary.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Date Portion
              Container(
                width: 80,
                decoration: BoxDecoration(
                  gradient: UltimateTheme.brandGradientSoft,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('MMM').format(event.startTime).toUpperCase(),
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.w900,
                        color: UltimateTheme.primary,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd').format(event.startTime),
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: UltimateTheme.textMain,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              // Dashed Line Separator
              CustomPaint(
                size: const Size(1, double.infinity),
                painter: DashedLinePainter(
                    color: UltimateTheme.primary.withValues(alpha: 0.1)),
              ),
              // Content Portion
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        event.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: UltimateTheme.textMain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded,
                              size: 14, color: UltimateTheme.secondary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              event.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: UltimateTheme.textSub,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Action Indicator
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: UltimateTheme.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward_ios_rounded,
                        color: UltimateTheme.primary, size: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 80).ms).slideX(begin: 0.1);
  }

  void _showAddEventDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        title: Text('New Event',
            style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold, fontSize: 24)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MaterialTextFormField(
                  controller: ref.read(eventProvider.notifier).titleController,
                  hintText: 'Event Title',
                  prefixIcon: const Icon(Icons.title_rounded),
                ),
                const SizedBox(height: 16),
                MaterialTextFormField(
                  controller:
                      ref.read(eventProvider.notifier).descriptionController,
                  hintText: 'Description',
                  maxLines: 3,
                  prefixIcon: const Icon(Icons.description_outlined),
                ),
                const SizedBox(height: 16),
                MaterialTextFormField(
                  controller:
                      ref.read(eventProvider.notifier).locationController,
                  hintText: 'Location',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                const SizedBox(height: 16),
                MaterialTextFormField(
                  controller:
                      ref.read(eventProvider.notifier).organizedByController,
                  hintText: 'Organized By',
                  prefixIcon: const Icon(Icons.corporate_fare_rounded),
                ),
                const SizedBox(height: 24),
                Consumer(
                  builder: (_, ref, __) {
                    final date = ref.watch(eventProvider).selectedDate;
                    return InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: UltimateTheme.primary,
                                  onPrimary: Colors.white,
                                  onSurface: UltimateTheme.textMain,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          ref.read(eventProvider.notifier).updateDate(picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: UltimateTheme.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color:
                                  UltimateTheme.primary.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month_rounded,
                                color: UltimateTheme.primary),
                            const SizedBox(width: 12),
                            Text(
                              date != null
                                  ? DateFormat('MMMM dd, yyyy').format(date)
                                  : "Select Date",
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: date != null
                                    ? UltimateTheme.textMain
                                    : UltimateTheme.textSub,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.edit_calendar_rounded,
                                color: UltimateTheme.primary, size: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: [
          Row(
            children: [
              Expanded(
                child: BorderlessButton(
                  onPressed: () => context.pop(),
                  label: const Text('Cancel'),
                  backgroundColor:
                      UltimateTheme.textSub.withValues(alpha: 0.05),
                  splashColor: UltimateTheme.textSub,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BorderlessButton(
                  onPressed: () {
                    ref.read(eventProvider.notifier).addEvent();
                    context.pop();
                  },
                  label: const Text('Add Event'),
                  backgroundColor: UltimateTheme.primary.withValues(alpha: 0.1),
                  splashColor: UltimateTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 10;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    while (startY < size.height - 10) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
