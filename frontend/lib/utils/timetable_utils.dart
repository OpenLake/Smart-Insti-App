import 'package:flutter/material.dart';
import '../models/acad_timetable.dart';
import '../models/acad_course.dart';

class SlotInfo {
  final int day;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  SlotInfo(this.day, this.startTime, this.endTime);
}

class TimetableUtils {
  // Raw slot definitions based on the provided timetable
  static final List<Map<String, dynamic>> _rawFullSchedule = [
    {'day': DateTime.monday, 'time': '08:30-09:25', 'slots': ['A']},
    {'day': DateTime.monday, 'time': '09:30-10:25', 'slots': ['B', 'N']},
    {'day': DateTime.monday, 'time': '10:30-11:25', 'slots': ['C', 'N']},
    {'day': DateTime.monday, 'time': '11:30-12:25', 'slots': ['E', 'N']},
    {'day': DateTime.monday, 'time': '12:30-13:25', 'slots': ['G']},
    {'day': DateTime.monday, 'time': '14:30-15:25', 'slots': ['K', 'O']},
    {'day': DateTime.monday, 'time': '15:30-16:25', 'slots': ['L', 'O']},
    {'day': DateTime.monday, 'time': '16:30-17:25', 'slots': ['I', 'O']},

    {'day': DateTime.tuesday, 'time': '08:30-09:25', 'slots': ['B']},
    {'day': DateTime.tuesday, 'time': '09:30-10:25', 'slots': ['D', 'V']},
    {'day': DateTime.tuesday, 'time': '10:30-11:25', 'slots': ['C', 'V']},
    {'day': DateTime.tuesday, 'time': '11:30-12:25', 'slots': ['X', 'V']},
    {'day': DateTime.tuesday, 'time': '12:30-13:25', 'slots': ['H']},
    {'day': DateTime.tuesday, 'time': '14:30-15:25', 'slots': ['L', 'W']},
    {'day': DateTime.tuesday, 'time': '15:30-16:25', 'slots': ['J', 'W']},
    {'day': DateTime.tuesday, 'time': '16:30-17:25', 'slots': ['M', 'W']},

    {'day': DateTime.wednesday, 'time': '08:30-09:25', 'slots': ['E']},
    {'day': DateTime.wednesday, 'time': '09:30-10:25', 'slots': ['A', 'P']},
    {'day': DateTime.wednesday, 'time': '10:30-11:25', 'slots': ['D', 'P']},
    {'day': DateTime.wednesday, 'time': '11:30-12:25', 'slots': ['F', 'P']},
    {'day': DateTime.wednesday, 'time': '12:30-13:25', 'slots': ['G']},
    {'day': DateTime.wednesday, 'time': '14:30-15:25', 'slots': ['K', 'Q']},
    {'day': DateTime.wednesday, 'time': '15:30-16:25', 'slots': ['M', 'Q']},
    {'day': DateTime.wednesday, 'time': '16:30-17:25', 'slots': ['I', 'Q']},

    {'day': DateTime.thursday, 'time': '08:30-09:25', 'slots': ['F']},
    {'day': DateTime.thursday, 'time': '09:30-10:25', 'slots': ['B', 'R']},
    {'day': DateTime.thursday, 'time': '10:30-11:25', 'slots': ['C', 'R']},
    {'day': DateTime.thursday, 'time': '11:30-12:25', 'slots': ['E', 'R']},
    {'day': DateTime.thursday, 'time': '12:30-13:25', 'slots': ['H']},
    {'day': DateTime.thursday, 'time': '14:30-15:25', 'slots': ['L', 'S']},
    {'day': DateTime.thursday, 'time': '15:30-16:25', 'slots': ['M', 'S']},
    {'day': DateTime.thursday, 'time': '16:30-17:25', 'slots': ['J', 'S']},

    {'day': DateTime.friday, 'time': '08:30-09:25', 'slots': ['G']},
    {'day': DateTime.friday, 'time': '09:30-10:25', 'slots': ['A', 'T']},
    {'day': DateTime.friday, 'time': '10:30-11:25', 'slots': ['D', 'T']},
    {'day': DateTime.friday, 'time': '11:30-12:25', 'slots': ['F', 'T']},
    {'day': DateTime.friday, 'time': '12:30-13:25', 'slots': ['H']},
    {'day': DateTime.friday, 'time': '14:30-15:25', 'slots': ['K', 'U']},
    {'day': DateTime.friday, 'time': '15:30-16:25', 'slots': ['J', 'U']},
    {'day': DateTime.friday, 'time': '16:30-17:25', 'slots': ['I', 'U']},
  ];

  static Map<String, SlotInfo>? _resolvedSlots;

  static void _ensureResolved() {
    if (_resolvedSlots != null) return;
    _resolvedSlots = {};

    // For each possible letter A-Z
    final letters = <String>{};
    for (var entry in _rawFullSchedule) {
      for (String s in entry['slots']) {
        letters.add(s);
      }
    }

    for (String letter in letters) {
      // Find all occurrences of this letter in the schedule
      final occurrences = <Map<String, dynamic>>[];
      for (var entry in _rawFullSchedule) {
        if ((entry['slots'] as List).contains(letter)) {
          occurrences.add(entry);
        }
      }

      // Order them by day then time to assign A1, A2...
      // (The defined order in _rawFullSchedule is already mostly sorted)
      for (int i = 0; i < occurrences.length; i++) {
        final entry = occurrences[i];
        final timeParts = (entry['time'] as String).split('-');
        final startParts = timeParts[0].split(':');
        final endParts = timeParts[1].split(':');

        final info = SlotInfo(
          entry['day'],
          TimeOfDay(
              hour: int.parse(startParts[0]), minute: int.parse(startParts[1])),
          TimeOfDay(
              hour: int.parse(endParts[0]), minute: int.parse(endParts[1])),
        );

        _resolvedSlots!["$letter${i + 1}"] = info;
      }
    }
  }

  static List<Map<String, dynamic>> getTodaysClasses(
      List<AcadTimetable> allTimetables, List<String> userSelectedCourseCodes) {
    _ensureResolved();
    final now = DateTime.now();
    return getClassesForDay(
        allTimetables, userSelectedCourseCodes, now.weekday);
  }

  static List<Map<String, dynamic>> getClassesForDay(
      List<AcadTimetable> allTimetables,
      List<String> userSelectedCourseCodes,
      int day) {
    _ensureResolved();
    List<Map<String, dynamic>> classes = [];

    for (var timetable in allTimetables) {
      if (userSelectedCourseCodes.contains(timetable.code)) {
        _addCalculatedSlot(
            classes, timetable, timetable.lectureSlot, day, "Lecture");
        _addCalculatedSlot(
            classes, timetable, timetable.tutorialSlot, day, "Tutorial");
        _addCalculatedSlot(classes, timetable, timetable.labSlot, day, "Lab");
      }
    }

    // Sort by time
    classes.sort((a, b) {
      final timeA = a['startTime'] as TimeOfDay;
      final timeB = b['startTime'] as TimeOfDay;
      if (timeA.hour != timeB.hour) return timeA.hour.compareTo(timeB.hour);
      return timeA.minute.compareTo(timeB.minute);
    });

    return classes;
  }

  static Map<int, List<Map<String, dynamic>>> getWeeklyClasses(
      List<AcadTimetable> allTimetables, List<String> userSelectedCourseCodes) {
    _ensureResolved();
    Map<int, List<Map<String, dynamic>>> weekly = {};

    for (int day = 1; day <= 5; day++) {
      weekly[day] =
          getClassesForDay(allTimetables, userSelectedCourseCodes, day);
    }

    return weekly;
  }

  static void _addCalculatedSlot(List<Map<String, dynamic>> list,
      AcadTimetable timetable, String slotStr, int today, String type) {
    if (slotStr == "NA" || slotStr.isEmpty) return;

    final inputSlots = slotStr.split(',').map((s) => s.trim());
    for (final inputSlot in inputSlots) {
      // 1. Try exact match (e.g., A1, B2)
      if (_resolvedSlots!.containsKey(inputSlot)) {
        final info = _resolvedSlots![inputSlot]!;
        if (info.day == today) {
          _addToResult(list, timetable, inputSlot, info, type);
        }
      } else {
        // 2. Try prefix match if it's a single letter or non-numbered slot (e.g., 'A')
        // Match all slots that start with this letter and are on the correct day
        _resolvedSlots!.forEach((key, info) {
          // If input is 'A', it matches 'A1', 'A2', 'A3'
          // We check if the key starts with inputSlot and the remaining part is numeric
          if (info.day == today) {
            bool isMatch = false;
            if (key == inputSlot) {
              isMatch = true;
            } else if (key.startsWith(inputSlot)) {
              final suffix = key.substring(inputSlot.length);
              if (int.tryParse(suffix) != null) {
                isMatch = true;
              }
            }

            if (isMatch) {
              _addToResult(list, timetable, key, info, type);
            }
          }
        });
      }
    }
  }

  static void _addToResult(List<Map<String, dynamic>> list,
      AcadTimetable timetable, String slotName, SlotInfo info, String type) {
    // Avoid duplicates for the same course-time
    bool exists = list.any((item) =>
        item['timetable'].code == timetable.code &&
        item['startTime'] == info.startTime);
    if (exists) return;

    list.add({
      'timetable': timetable,
      'slot': slotName,
      'startTime': info.startTime,
      'endTime': info.endTime,
      'type': type,
      'venue': type == "Lecture"
          ? timetable.lectureVenue
          : (type == "Lab" ? timetable.labVenue : timetable.tutorialVenue),
    });
  }

  static Map<String, dynamic>? getNextClass(
      List<Map<String, dynamic>> todaysSortedClasses) {
    final now = DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);

    for (var item in todaysSortedClasses) {
      final startTime = item['startTime'] as TimeOfDay;
      if (startTime.hour > currentTime.hour ||
          (startTime.hour == currentTime.hour &&
              startTime.minute > currentTime.minute)) {
        return item;
      }
    }
    return null;
  }

  static Map<String, dynamic>? getOngoingClass(
      List<Map<String, dynamic>> todaysSortedClasses) {
    final now = DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);

    for (var item in todaysSortedClasses) {
      final startTime = item['startTime'] as TimeOfDay;
      final endTime = item['endTime'] as TimeOfDay;

      bool isAfterStart = (currentTime.hour > startTime.hour ||
          (currentTime.hour == startTime.hour &&
              currentTime.minute >= startTime.minute));
      bool isBeforeEnd = (currentTime.hour < endTime.hour ||
          (currentTime.hour == endTime.hour &&
              currentTime.minute < endTime.minute));

      if (isAfterStart && isBeforeEnd) {
        return item;
      }
    }
    return null;
  }
}
