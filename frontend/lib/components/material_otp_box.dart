import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/ultimate_theme.dart';

class MaterialOTPBox extends StatelessWidget {
  const MaterialOTPBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.onChanged,
    this.size = 48.0,
    this.fontSize = 20.0,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final void Function(String?)? onChanged;
  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: size,
      height: size,
      child: TextFormField(
        showCursor: false,
        controller: controller,
        focusNode: focusNode,
        onChanged: (value) {
          if (value.length == 1) {
            focusNode.nextFocus();
          }
          if (onChanged != null) onChanged!(value);
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: GoogleFonts.spaceGrotesk(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: UltimateTheme.primary,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: hintText,
          hintStyle: GoogleFonts.spaceGrotesk(
            fontSize: fontSize,
            color: UltimateTheme.primary.withValues(alpha: 0.1),
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          fillColor: UltimateTheme.primary.withValues(alpha: 0.05),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: UltimateTheme.primary.withValues(alpha: 0.1),
                width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: UltimateTheme.primary, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
