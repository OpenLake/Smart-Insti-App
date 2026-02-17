
import 'package:smart_insti_app/models/mess_menu.dart';

class MenuParser {
  static MessMenu parseTsv(String content) {
    List<String> lines = content.split('\n');
    
    // Initialize empty menu structure
    Map<String, Map<String, List<String>>> menuData = {
      'Monday': {'Breakfast': [], 'Lunch': [], 'Snacks': [], 'Dinner': []},
      'Tuesday': {'Breakfast': [], 'Lunch': [], 'Snacks': [], 'Dinner': []},
      'Wednesday': {'Breakfast': [], 'Lunch': [], 'Snacks': [], 'Dinner': []},
      'Thursday': {'Breakfast': [], 'Lunch': [], 'Snacks': [], 'Dinner': []},
      'Friday': {'Breakfast': [], 'Lunch': [], 'Snacks': [], 'Dinner': []},
      'Saturday': {'Breakfast': [], 'Lunch': [], 'Snacks': [], 'Dinner': []},
      'Sunday': {'Breakfast': [], 'Lunch': [], 'Snacks': [], 'Dinner': []},
    };

    List<String> headerDays = [];
    String currentMealType = '';

    for (var line in lines) {
      if (line.trim().isEmpty) continue;
      
      // Split by tab
      List<String> cells = line.split('\t').map((e) => e.trim()).toList();
      if (cells.isEmpty) continue;

      String firstCell = cells[0];

      // 1. Detect Header Row
      if (firstCell.startsWith('Days')) {
        // Cells 1..7 should be days
        // We expect: Days, Monday, Tuesday, ... Sunday
        headerDays = [];
        for (int i = 1; i < cells.length; i++) {
          if (cells[i].isNotEmpty) {
            headerDays.add(cells[i]);
          }
        }
        continue;
      }

      // 2. Detect Meal Sections
      // Check for keywords in first cell
      if (firstCell.contains('BF (Time)') || firstCell.contains('Breakfast')) {
        currentMealType = 'Breakfast';
        continue; 
      } else if (firstCell.contains('Lunch')) {
        currentMealType = 'Lunch';
        continue;
      } else if (firstCell.contains('Snacks')) {
        currentMealType = 'Snacks';
        continue;
      } else if (firstCell.contains('Dinner')) {
        currentMealType = 'Dinner';
        continue;
      }

      // 3. Parse Items
      if (currentMealType.isNotEmpty && headerDays.isNotEmpty) {
        // Iterate through days
        for (int i = 0; i < headerDays.length; i++) {
          // Column index in TSV is i + 1 (since col 0 is label)
          if (i + 1 < cells.length) {
            String item = cells[i + 1];
            if (item.isNotEmpty && item != '-') {
              String dayName = headerDays[i];
              if (menuData.containsKey(dayName)) {
                // Optionally prepend category name from firstCell if needed
                // e.g. "Fruits: Banana"
                // But typically just showing the item is cleaner given the UI
                menuData[dayName]![currentMealType]!.add(item);
              }
            }
          }
        }
      }
    }

    return MessMenu(
      kitchenName: "Hostel Mess Menu", 
      messMenu: menuData,
    );
  }
}
