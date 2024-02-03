import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class AchievementsEditWidget extends StatelessWidget {
  final TextEditingController achievementsController;
  List<DateTime?> _selectedDate;

  AchievementsEditWidget({
    required this.achievementsController,
    Key? key,
  })  : _selectedDate = [DateTime.now()], // Initialize _selectedDate
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Achievements',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: achievementsController,
          decoration: const InputDecoration(labelText: 'Achievement'),
        ),
        CalendarDatePicker2(
          config: CalendarDatePicker2Config(),
          value: _selectedDate,
          onValueChanged: (dates) {
            if (dates != null && dates.isNotEmpty) {
              _selectedDate = [dates.first];
            }
          },
        ),
      ],
    );
  }
}
// class AchievementsEditWidget extends StatelessWidget {
//   final TextEditingController achievementsController;
//   final DateTime? _selectedDate;

//   AchievementsEditWidget({required this.achievementsController})
//       : _selectedDate = DateTime.now(); // Initialize _selectedDate

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Achievements',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         TextFormField(
//           controller: achievementsController,
//           decoration: const InputDecoration(labelText: 'Achievement'),
//         ),
//         // Add more fields like description, date picker, etc.
//         CalendarDatePicker2(
//           config: CalendarDatePicker2Config(),
//           value: _selectedDate,
//           onValueChanged: (dates) {
//             if (dates != null && dates.isNotEmpty) {
//               _selectedDate = dates.first;
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
