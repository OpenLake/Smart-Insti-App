import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MaterialTextFormField extends StatelessWidget {
  const MaterialTextFormField({
    super.key,
    this.controller,
    this.validator,
    required this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.contentPadding,
    this.hintColor,
    this.enabled,
    this.controllerLessValue,
    this.onTap,
    this.maxLength,
    this.maxLines,
    this.textAlign,
    this.inputFormatters,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function? onChanged;
  final Function? onSubmitted;
  final String hintText;
  final Color? hintColor;
  final EdgeInsets? contentPadding;
  final bool? enabled;
  final String? controllerLessValue;
  final TextAlign? textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final Function? onTap;
  final int? maxLength;
  final int? maxLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TextEditingController substituteController = TextEditingController();
    if (controllerLessValue != null) {
      substituteController.text = controllerLessValue!;
    }

    return TextFormField(
      onTap: () => onTap != null ? onTap!() : null,
      enabled: enabled ?? true,
      controller: controller ?? substituteController,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      autofocus: autofocus,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      onChanged: (value) => onChanged != null ? onChanged!(value) : null,
      validator: (value) => validator != null ? validator!(value) : null,
      onFieldSubmitted: (value) =>
          onSubmitted != null ? onSubmitted!(value) : null,
      cursorColor: theme.colorScheme.primary,
      style: GoogleFonts.inter(
        color: theme.textTheme.bodyLarge?.color,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        contentPadding: contentPadding,
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          color: hintColor ??
              theme.textTheme.bodyMedium?.color
                  ?.withAlpha(128), // Using withAlpha for 0.5 opacity
          fontSize: 15,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
