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
      if (ref.read(authProvider.notifier).tokenCheckProgress != LoadingState.progress && context.mounted) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(context, AuthConstants.generalAuthLabel.toLowerCase());
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTimetableDialog(context, ref),
        backgroundColor: UltimateTheme.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text("New Timetable", style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, color: Colors.white)),
      ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack),
      body: Consumer(
        builder: (_, ref, __) {
          final timetables = ref.watch(timetableProvider).timetables;
          if (timetables.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month_rounded, size: 64, color: UltimateTheme.textSub.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text("No timetables found", style: GoogleFonts.inter(color: UltimateTheme.textSub)),
                ],
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final timetable = timetables[index];
                      return _buildTimetableCard(context, timetable, ref, index);
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

  Widget _buildTimetableCard(BuildContext context, timetable, WidgetRef ref, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UltimateTheme.primary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: UltimateTheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.table_chart_rounded, color: UltimateTheme.primary),
        ),
        title: Text(
          timetable.name,
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 16, color: UltimateTheme.textMain),
        ),
        subtitle: Text(
          "${timetable.rows} Rows × ${timetable.columns} Columns",
          style: GoogleFonts.inter(fontSize: 12, color: UltimateTheme.textSub),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
          onPressed: () => ref.read(timetableProvider.notifier).deleteTimetable(timetable),
        ),
        onTap: () {
          ref.read(timetableProvider.notifier).initTileControllersAndTime(timetable: timetable);
          context.push('/user_home/timetables/editor');
        },
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
  }

  void _showAddTimetableDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text('New Timetable', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold)),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialTextFormField(
                hintText: "Timetable Name",
                controller: ref.read(timetableProvider).timetableNameController,
                validator: (value) => Validators.nameValidator(value),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: MaterialTextFormField(
                      controller: ref.read(timetableProvider).rowsController,
                      textAlign: TextAlign.center,
                      enabled: false,
                      hintText: 'Rows',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.close_rounded, size: 16, color: UltimateTheme.textSub),
                  ),
                  Expanded(
                    child: Tooltip(
                      key: _toolTipKey,
                      message: "Enter columns",
                      child: MaterialTextFormField(
                        hintText: "Cols",
                        textAlign: TextAlign.center,
                        controller: ref.read(timetableProvider).columnsController,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Include Saturday?", style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                  Consumer(
                    builder: (_, ref, __) => AnimatedToggleSwitch.dual(
                      height: 40,
                      spacing: 12,
                      onTap: (value) => ref.read(timetableProvider.notifier).toggleIncludeSaturday(),
                      current: ref.watch(timetableProvider).includeSaturday,
                      first: true,
                      second: false,
                      styleBuilder: (value) => value
                          ? ToggleStyle(
                              indicatorColor: UltimateTheme.primary,
                              backgroundColor: UltimateTheme.primary.withOpacity(0.1),
                              borderColor: Colors.transparent,
                            )
                          : ToggleStyle(
                              indicatorColor: Colors.redAccent,
                              backgroundColor: Colors.redAccent.withOpacity(0.1),
                              borderColor: Colors.transparent,
                            ),
                      iconBuilder: (value) => Icon(
                        value ? Icons.check_rounded : Icons.close_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          BorderlessButton(
            onPressed: () {
              ref.read(timetableProvider.notifier).clearControllers();
              context.pop();
            },
            label: const Text('Cancel'),
            backgroundColor: UltimateTheme.textSub.withOpacity(0.05),
            splashColor: UltimateTheme.textSub,
          ),
          BorderlessButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (ref.read(timetableProvider).columnsController.text.isEmpty) {
                  _toolTipKey.currentState?.ensureTooltipVisible();
                } else {
                  context.pop();
                  ref.read(timetableProvider.notifier).initTileControllersAndTime();
                  context.push('/user_home/timetables/editor');
                }
              }
            },
            label: const Text('Create'),
            backgroundColor: UltimateTheme.primary.withOpacity(0.1),
            splashColor: UltimateTheme.primary,
          ),
        ],
      ),
    );
  }
}
