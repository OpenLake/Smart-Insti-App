import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/components/borderless_button.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/constants/constants.dart';
import 'package:smart_insti_app/provider/timetable_provider.dart';
import '../../provider/auth_provider.dart';

class Timetables extends ConsumerWidget {
  Timetables({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<TooltipState> _toolTipKey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider.notifier).tokenCheckProgress !=
              LoadingState.progress &&
          context.mounted) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(
            context, AuthConstants.generalAuthLabel.toLowerCase());
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTimetableDialog(context, ref),
        backgroundColor: UltimateTheme.primary,
        elevation: 4,
        icon: const Icon(Icons.add_task_rounded, color: Colors.white),
        label: Text("New Schedule",
            style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold, color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack),
      body: Consumer(
        builder: (_, ref, __) {
          final timetables = ref.watch(timetableProvider).timetables;
          if (timetables.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: UltimateTheme.primary.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.calendar_today_rounded,
                          size: 60,
                          color: UltimateTheme.primary.withValues(alpha: 0.3)),
                    ),
                    const SizedBox(height: 24),
                    Text("No schedules yet",
                        style: GoogleFonts.spaceGrotesk(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: UltimateTheme.textMain)),
                    const SizedBox(height: 8),
                    Text(
                        "Create your first timetable to keep track of your classes and labs.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            color: UltimateTheme.textSub, height: 1.5)),
                  ],
                ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
              ),
            );
          }
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final timetable = timetables[index];
                      return _buildTimetableCard(
                          context, timetable, ref, index);
                    },
                    childCount: timetables.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimetableCard(
      BuildContext context, timetable, WidgetRef ref, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border:
            Border.all(color: UltimateTheme.primary.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 5)),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: UltimateTheme.brandGradientSoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.calendar_view_week_rounded,
              color: UltimateTheme.primary, size: 24),
        ),
        title: Text(
          timetable.name,
          style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: UltimateTheme.textMain),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(Icons.grid_4x4_rounded,
                  size: 14,
                  color: UltimateTheme.textSub.withValues(alpha: 0.6)),
              const SizedBox(width: 6),
              Text(
                "${timetable.rows} × ${timetable.columns} Layout",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: UltimateTheme.textSub,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: Colors.redAccent, size: 18),
            onPressed: () =>
                ref.read(timetableProvider.notifier).deleteTimetable(timetable),
          ),
        ),
        onTap: () {
          ref
              .read(timetableProvider.notifier)
              .initTileControllersAndTime(timetable: timetable);
          context.push('/user_home/timetables/editor');
        },
      ),
    ).animate().fadeIn(delay: (index * 60).ms).slideX(begin: 0.05);
  }

  void _showAddTimetableDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        title: Text('New Schedule',
            style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold, fontSize: 24)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MaterialTextFormField(
                    hintText: "Schedule Name (e.g. Sem 6)",
                    controller:
                        ref.read(timetableProvider).timetableNameController,
                    validator: (value) => Validators.nameValidator(value),
                    prefixIcon: const Icon(Icons.label_outline_rounded),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: MaterialTextFormField(
                          controller:
                              ref.read(timetableProvider).rowsController,
                          textAlign: TextAlign.center,
                          enabled: false,
                          hintText: 'Rows',
                          prefixIcon:
                              const Icon(Icons.height_rounded, size: 18),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.close_rounded,
                            size: 16, color: UltimateTheme.textSub),
                      ),
                      Expanded(
                        child: Tooltip(
                          key: _toolTipKey,
                          message: "Numbers of periods per day",
                          child: MaterialTextFormField(
                            hintText: "Cols",
                            textAlign: TextAlign.center,
                            controller:
                                ref.read(timetableProvider).columnsController,
                            prefixIcon:
                                const Icon(Icons.view_column_rounded, size: 18),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: UltimateTheme.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: UltimateTheme.primary.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.today_rounded,
                                color: UltimateTheme.primary, size: 20),
                            const SizedBox(width: 12),
                            Text("Include Saturday",
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: UltimateTheme.textMain)),
                          ],
                        ),
                        Consumer(
                          builder: (_, ref, __) => AnimatedToggleSwitch.dual(
                            height: 32,
                            spacing: 8,
                            onTap: (value) => ref
                                .read(timetableProvider.notifier)
                                .toggleIncludeSaturday(),
                            current:
                                ref.watch(timetableProvider).includeSaturday,
                            first: true,
                            second: false,
                            styleBuilder: (value) => value
                                ? ToggleStyle(
                                    indicatorColor: UltimateTheme.primary,
                                    backgroundColor: UltimateTheme.primary
                                        .withValues(alpha: 0.1),
                                    borderColor: Colors.transparent,
                                  )
                                : ToggleStyle(
                                    indicatorColor: UltimateTheme.textSub
                                        .withValues(alpha: 0.3),
                                    backgroundColor: UltimateTheme.textSub
                                        .withValues(alpha: 0.05),
                                    borderColor: Colors.transparent,
                                  ),
                            iconBuilder: (value) => Icon(
                              value ? Icons.check_rounded : Icons.close_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: [
          Row(
            children: [
              Expanded(
                child: BorderlessButton(
                  onPressed: () {
                    ref.read(timetableProvider.notifier).clearControllers();
                    context.pop();
                  },
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
                    if (_formKey.currentState!.validate()) {
                      if (ref
                          .read(timetableProvider)
                          .columnsController
                          .text
                          .isEmpty) {
                        _toolTipKey.currentState?.ensureTooltipVisible();
                      } else {
                        context.pop();
                        ref
                            .read(timetableProvider.notifier)
                            .initTileControllersAndTime();
                        context.push('/user_home/timetables/editor');
                      }
                    }
                  },
                  label: const Text('Create'),
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
