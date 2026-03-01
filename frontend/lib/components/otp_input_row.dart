import 'package:flutter/material.dart';
import 'package:smart_insti_app/components/material_otp_box.dart';

class OtpInputRow extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  const OtpInputRow({
    super.key,
    required this.controllers,
    required this.focusNodes,
  });

  @override
  Widget build(BuildContext context) {
    final int count = controllers.length;
    final double screenWidth = MediaQuery.of(context).size.width;
    // Calculate a reasonable size to fit all boxes with some padding
    // Assuming a max width of 400 for the login form
    final double containerWidth = screenWidth > 400 ? 400 : screenWidth - 40;
    final double boxSize = (containerWidth / count) - 8;
    final double fontSize = boxSize * 0.5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(count, (index) {
        return MaterialOTPBox(
          controller: controllers[index],
          focusNode: focusNodes[index],
          hintText: (index + 1).toString(),
          size: boxSize > 48 ? 48 : boxSize,
          fontSize: fontSize > 24 ? 24 : fontSize,
          onChanged: (value) {
            if (value != null && value.isEmpty && index > 0) {
              focusNodes[index - 1].requestFocus();
            }
          },
        );
      }),
    );
  }
}
