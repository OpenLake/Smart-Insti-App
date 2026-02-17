import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:smart_insti_app/components/choice_selector.dart';
import 'package:smart_insti_app/models/mess_menu.dart';
import 'package:smart_insti_app/provider/menu_provider.dart';
import '../../constants/constants.dart';
import '../../provider/auth_provider.dart';

class UserMessMenu extends ConsumerWidget {
  const UserMessMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuState = ref.watch(menuProvider);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider.notifier).tokenCheckProgress != LoadingState.progress && context.mounted) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(context, AuthConstants.generalAuthLabel.toLowerCase());
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: menuState.loadingState == LoadingState.progress
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // 1. Kitchen Selector
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: ChoiceSelector(
                      onChanged: (value) => ref.read(menuProvider.notifier).setSelectViewMenu(value),
                      value: menuState.selectedViewMenu,
                      items: [
                        for (String i in menuState.messMenus.keys)
                          DropdownMenuItem<String>(value: i, child: Text(i)),
                      ],
                      hint: 'Select Kitchen',
                    ),
                  ),
                ),

                // 2. Meal Type Selector (Slide Switcher)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: SlideSwitcher(
                      onSelect: (index) => ref.read(menuProvider.notifier).selectMealType(index),
                      containerHeight: 50,
                      containerWight: double.infinity,
                      containerBorderRadius: 16,
                      slidersColors: [UltimateTheme.primary],
                      containerColor: UltimateTheme.primary.withOpacity(0.08),
                      children: MessMenuConstants.mealTypes.map((e) => Text(
                        (e as Text).data!,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: (menuState.selectedMealTypeIndex == MessMenuConstants.mealTypes.indexOf(e))
                              ? Colors.white
                              : UltimateTheme.textSub,
                        ),
                      )).toList(),
                    ),
                  ),
                ),

                // 3. Main Content: Day Selector + Meal List
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Meal Items List
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${ref.watch(menuProvider.notifier).getWeekDay(menuState.selectedWeekdayIndex)}'s ${ref.watch(menuProvider.notifier).getMealType(menuState.selectedMealTypeIndex)}",
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: UltimateTheme.textMain,
                                ),
                              ).animate().fadeIn().slideX(begin: -0.1),
                              const SizedBox(height: 16),
                              if (menuState.selectedViewMenu != null) ...[
                                ..._buildMealItems(menuState),
                              ] else ...[
                                _buildEmptyState("No menu selected"),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Vertical Day Selector
                        SlideSwitcher(
                          onSelect: (index) => ref.read(menuProvider.notifier).selectWeekday(index),
                          containerHeight: 350,
                          containerWight: 60,
                          containerBorderRadius: 16,
                          direction: Axis.vertical,
                          slidersColors: [UltimateTheme.accent],
                          containerColor: UltimateTheme.accent.withOpacity(0.08),
                          children: MessMenuConstants.weekdays.map((e) => RotatedBox(
                            quarterTurns: -1,
                            child: Text(
                              (e as Text).data!,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: (menuState.selectedWeekdayIndex == MessMenuConstants.weekdays.indexOf(e))
                                    ? Colors.white
                                    : UltimateTheme.textSub,
                              ),
                            ),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _buildMealItems(menuState) {
    final String weekDay = MessMenuConstants.weekdaysNames[menuState.selectedWeekdayIndex];
    final String mealType = MessMenuConstants.mealTypeNames[menuState.selectedMealTypeIndex];
    MessMenu? selectedMenu = menuState.messMenus[menuState.selectedViewMenu];
    List<String>? items = selectedMenu?.messMenu?[weekDay]?[mealType];

    if (items == null || items.isEmpty) {
      return [_buildEmptyState("No items today")];
    }

    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: UltimateTheme.primary.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: UltimateTheme.primary.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: UltimateTheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.restaurant_rounded, color: UltimateTheme.primary, size: 16),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: UltimateTheme.textMain,
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
    }).toList();
  }

  Widget _buildEmptyState(String message) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: UltimateTheme.textSub.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UltimateTheme.textSub.withOpacity(0.1), style: BorderStyle.none),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu_rounded, size: 48, color: UltimateTheme.textSub.withOpacity(0.3)),
          const SizedBox(height: 12),
          Text(message, style: GoogleFonts.inter(color: UltimateTheme.textSub)),
        ],
      ),
    );
  }
}
