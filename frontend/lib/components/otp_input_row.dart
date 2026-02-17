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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MaterialOTPBox(
          controller: controllers[0],
          focusNode: focusNodes[0],
          hintText: 'O',
        ),
        MaterialOTPBox(
          controller: controllers[1],
          focusNode: focusNodes[1],
          hintText: 'T',
          onChanged: (value) {
            if (value != null && value.isEmpty) {
              focusNodes[0].requestFocus();
            }
          },
        ),
        MaterialOTPBox(
          controller: controllers[2],
          focusNode: focusNodes[2],
          hintText: 'P',
          onChanged: (value) {
            if (value != null && value.isEmpty) {
              focusNodes[1].requestFocus();
            }
          },
        ),
        MaterialOTPBox(
          controller: controllers[3],
          focusNode: focusNodes[3],
          hintText: ':)',
          onChanged: (value) {
            if (value != null && value.isEmpty) {
              focusNodes[2].requestFocus();
            }
          },
        )
      ],
    );
  }
}
