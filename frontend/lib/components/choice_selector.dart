import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/ultimate_theme.dart';

class ChoiceSelector extends StatelessWidget {
  const ChoiceSelector({
    super.key,
    required this.onChanged,
    required this.value,
    required this.items,
    required this.hint,
  });

  final Function onChanged;
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: SearchChoices.single(
        style: GoogleFonts.inter(
          color: UltimateTheme.textMain,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        items: items,
        value: value,
        hint: Text(
          hint,
          style: GoogleFonts.inter(
            color: UltimateTheme.textSub,
            fontSize: 15,
          ),
        ),
        searchHint: null,
        onChanged: (value) => onChanged(value),
        dialogBox: false,
        isExpanded: true,
        displayClearIcon: false,
        fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
          return Container(
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
            child: InputDecorator(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                isDense: true,
                filled: true,
                fillColor: UltimateTheme.primary.withValues(alpha: 0.05),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: UltimateTheme.primary.withValues(alpha: 0.1)),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: UltimateTheme.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: fieldWidget,
            ),
          );
        },
        menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
        validator: null,
        menuBackgroundColor: Colors.white,
      ),
    );
  }
}
