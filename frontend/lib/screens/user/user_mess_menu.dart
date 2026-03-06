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

class UserMessMenu extends ConsumerWidget {
  const UserMessMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuState = ref.watch(menuProvider);

    // Auth check removed for Guest Access
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (ref.read(authProvider.notifier).tokenCheckProgress != LoadingState.progress && context.mounted) {
    //     ref.read(authProvider.notifier).verifyAuthTokenExistence(context, AuthConstants.generalAuthLabel.toLowerCase());
    //   }
    // });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: menuState.loadingState == LoadingState.progress
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Kitchen Selector
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Kitchen",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: UltimateTheme.textMain,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ChoiceSelector(
                          onChanged: (value) => ref
                              .read(menuProvider.notifier)
                              .setSelectViewMenu(value),
                          value: menuState.selectedViewMenu,
                          items: [
                            for (String i in menuState.messMenus.keys)
                              DropdownMenuItem<String>(
                                  value: i, child: Text(i)),
                          ],
                          hint: 'Select Kitchen',
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Meal Type Selector (Slide Switcher)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SlideSwitcher(
                        onSelect: (index) => ref
                            .read(menuProvider.notifier)
                            .selectMealType(index),
                        containerHeight: 52,
                        containerWight: double.infinity,
                        containerBorderRadius: 16,
                        slidersColors: [UltimateTheme.primary],
                        containerColor: Colors.transparent,
                        children: MessMenuConstants.mealTypeNames.map((name) {
                          bool isSelected = menuState.selectedMealTypeIndex ==
                              MessMenuConstants.mealTypeNames.indexOf(name);
                          return Text(
                            name,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : UltimateTheme.textSub,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                // 3. Main Content: Day Selector + Meal List
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vertical Day Selector (Day Rail)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: SlideSwitcher(
                            onSelect: (index) => ref
                                .read(menuProvider.notifier)
                                .selectWeekday(index),
                            containerHeight: 380,
                            containerWight: 56,
                            containerBorderRadius: 16,
                            direction: Axis.vertical,
                            slidersColors: [UltimateTheme.accent],
                            containerColor: Colors.transparent,
                            children:
                                MessMenuConstants.weekdaysNames.map((name) {
                              bool isSelected = menuState
                                      .selectedWeekdayIndex ==
                                  MessMenuConstants.weekdaysNames.indexOf(name);
                              return RotatedBox(
                                quarterTurns: -1,
                                child: Text(
                                  name.substring(0, 3).toUpperCase(),
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : UltimateTheme.textSub,
                                    letterSpacing: 1,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Meal Items List
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.wb_sunny_rounded,
                                      color: UltimateTheme.accent, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "${ref.watch(menuProvider.notifier).getWeekDay(menuState.selectedWeekdayIndex)}'s ${ref.watch(menuProvider.notifier).getMealType(menuState.selectedMealTypeIndex)}",
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: UltimateTheme.textMain,
                                      ),
                                    ),
                                  ),
                                ],
                              ).animate().fadeIn().slideX(begin: -0.1),
                              const SizedBox(height: 20),
                              if (menuState.selectedViewMenu != null) ...[
                                ..._buildMealItems(menuState),
                              ] else ...[
                                _buildEmptyState(
                                    "Please select a kitchen to view the menu"),
                              ],
                            ],
                          ),
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
    final String weekDay =
        MessMenuConstants.weekdaysNames[menuState.selectedWeekdayIndex];
    final String mealType =
        MessMenuConstants.mealTypeNames[menuState.selectedMealTypeIndex];
    MessMenu? selectedMenu = menuState.messMenus[menuState.selectedViewMenu];
    List<String>? items = selectedMenu?.messMenu?[weekDay]?[mealType];

    if (items == null || items.isEmpty) {
      return [_buildEmptyState("No menu items found for this meal")];
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
          border:
              Border.all(color: UltimateTheme.primary.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: UltimateTheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.restaurant_rounded,
                  color: UltimateTheme.primary, size: 18),
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
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        color: UltimateTheme.textSub.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border:
            Border.all(color: UltimateTheme.textSub.withValues(alpha: 0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: UltimateTheme.textSub.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.restaurant_menu_rounded,
                size: 40, color: UltimateTheme.textSub.withValues(alpha: 0.3)),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: UltimateTheme.textSub,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}
