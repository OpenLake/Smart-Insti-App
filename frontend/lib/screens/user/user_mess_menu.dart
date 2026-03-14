import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
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
    final Logger logger = Logger();
    logger.i("Building UserMessMenu. State: ${menuState.loadingState}, Menus Count: ${menuState.messMenus.length}");

    // Auth check removed for Guest Access
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (ref.read(authProvider.notifier).tokenCheckProgress != LoadingState.progress && context.mounted) {
    //     ref.read(authProvider.notifier).verifyAuthTokenExistence(context, AuthConstants.generalAuthLabel.toLowerCase());
    //   }
    // });

    return Scaffold(
      backgroundColor: UltimateTheme.background,
      body: SafeArea(
        child: menuState.loadingState == LoadingState.progress
            ? const Center(child: CircularProgressIndicator())
            : menuState.loadingState == LoadingState.error
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text("Failed to load mess menu",
                            style: GoogleFonts.inter(fontSize: 16)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () =>
                              ref.read(menuProvider.notifier).loadMenus(),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  )
                : CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // 1. Kitchen Selector
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select Kitchen",
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: UltimateTheme.textMain,
                                ),
                              ),
                              const SizedBox(height: 8),
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
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        sliver: SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ExcludeSemantics(
                              child: SlideSwitcher(
                                onSelect: (index) => ref
                                    .read(menuProvider.notifier)
                                    .selectMealType(index),
                                containerHeight: 44,
                                containerWight: MediaQuery.of(context).size.width - 40,
                                containerBorderRadius: 12,
                                slidersColors: [UltimateTheme.primary],
                                containerColor: Colors.transparent,
                                children: MessMenuConstants.mealTypeNames.map((name) {
                                  bool isSelected = menuState.selectedMealTypeIndex ==
                                      MessMenuConstants.mealTypeNames.indexOf(name);
                                  return Text(
                                    name,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : UltimateTheme.textSub,
                                      letterSpacing: -0.5,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 3. Main Content: Day Selector + Meal List
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
                        sliver: SliverToBoxAdapter(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Vertical Day Selector (Day Rail)
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ExcludeSemantics(
                                  child: SlideSwitcher(
                                    onSelect: (index) => ref
                                        .read(menuProvider.notifier)
                                        .selectWeekday(index),
                                    containerHeight: 330,
                                    containerWight: 48,
                                    containerBorderRadius: 12,
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
                                            fontSize: 10,
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
                              ),
                              const SizedBox(width: 16),
                              // Meal Items List
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (menuState.messMenus.isEmpty) ...[
                                      _buildEmptyState(
                                          "No kitchens found in database."),
                                    ] else if (menuState.selectedViewMenu != null) ...[
                                      ..._buildMealItems(menuState),
                                    ] else ...[
                                      _buildEmptyState(
                                          "Please select a kitchen"),
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

    return [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == items.length - 1;

            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: UltimateTheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          item,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: UltimateTheme.textMain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black.withValues(alpha: 0.04),
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
      ).animate().fadeIn().slideY(begin: 0.05),
    ];
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
