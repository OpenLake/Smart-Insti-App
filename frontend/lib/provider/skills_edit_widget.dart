import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SkillsEditWidget extends StatelessWidget {
  final TextEditingController skillsController;

  const SkillsEditWidget({required this.skillsController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Skills',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SfSlider(
          min: 0.0,
          max: 100.0,
          value: double.parse(skillsController.text),
          onChanged: (dynamic value) {
            skillsController.text = value.toStringAsFixed(0);
          },
        ),
      ],
    );
  }
}
