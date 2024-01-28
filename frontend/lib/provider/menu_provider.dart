// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
// import 'package:smart_insti_app/components/rounded_chip.dart';
// import 'package:smart_insti_app/constants/dummy_entries.dart';
// import 'package:smart_insti_app/models/mess_menu.dart';
// import '../constants/constants.dart';
// import 'dart:io';
//
//
// class MenuProvider extends ChangeNotifier {
//
//   final TextEditingController _kitchenNameController = TextEditingController();
//   final TextEditingController _itemNameController = TextEditingController();
//   String? selectedViewMenu;
//
//   TextEditingController get kitchenNameController => _kitchenNameController;
//   TextEditingController get itemNameController => _itemNameController;
//
//   final List<RoundedChip> items = [];
//   final Map<String,MessMenu> messMenus = DummyMenus.messMenus;
//   late MessMenu currentMenu;
//   final Logger _logger = Logger();
//
//   int selectedWeekdayIndex = 0;
//   int selectedMealTypeIndex = 0;
//
//   get weekday => MessMenuConstants.weekdaysShortToLong[MessMenuConstants.weekdays[selectedWeekdayIndex].data];
//   get mealType => MessMenuConstants.mealTypes[selectedMealTypeIndex].data;
//
//   void pickSpreadsheet() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       bool isSpreadsheet = result.files.single.path!.endsWith(".xlsx") ||
//           result.files.single.path!.endsWith(".xls") ||
//           result.files.single.path!.endsWith(".csv");
//       if (isSpreadsheet) {
//         File file = File(result.files.single.path!);
//
//         // TODO : Add code to send the spreadsheet to the backend
//
//         _logger.i("Picked file ${file.path}");
//       } else {
//         _logger.e("Picked file is not a spreadsheet");
//       }
//     } else {
//       _logger.e("No file picked");
//     }
//   }
//
//   void setSelectViewMenu(String? value){
//     selectedViewMenu = value;
//     notifyListeners();
//   }
//
//   void selectWeekday(int index) {
//     selectedWeekdayIndex = index;
//     notifyListeners();
//   }
//
//   void selectMealType(int index) {
//     selectedMealTypeIndex = index;
//     notifyListeners();
//   }
//
//   void clear() {
//     _kitchenNameController.clear();
//     _itemNameController.clear();
//     items.clear();
//     initMenu();
//     selectedWeekdayIndex = 0;
//     selectedMealTypeIndex = 0;
//     notifyListeners();
//   }
//
//
//   void initMenu(){
//     currentMenu = MessMenu();
//     currentMenu.messMenu = <String, Map<String, List<String>>>{
//       'Sunday': <String, List<String>>{
//         'Breakfast': <String>[],
//         'Lunch': <String>[],
//         'Snacks': <String>[],
//         'Dinner': <String>[],
//       },
//       'Monday': <String, List<String>>{
//         'Breakfast': <String>[],
//         'Lunch': <String>[],
//         'Snacks': <String>[],
//         'Dinner': <String>[],
//       },
//       'Tuesday': <String, List<String>>{
//         'Breakfast': <String>[],
//         'Lunch': <String>[],
//         'Snacks': <String>[],
//         'Dinner': <String>[],
//       },
//       'Wednesday': <String, List<String>>{
//         'Breakfast': <String>[],
//         'Lunch': <String>[],
//         'Snacks': <String>[],
//         'Dinner': <String>[],
//       },
//       'Thursday': <String, List<String>>{
//         'Breakfast': <String>[],
//         'Lunch': <String>[],
//         'Snacks': <String>[],
//         'Dinner': <String>[],
//       },
//       'Friday': <String, List<String>>{
//         'Breakfast': <String>[],
//         'Lunch': <String>[],
//         'Snacks': <String>[],
//         'Dinner': <String>[],
//       },
//       'Saturday': <String, List<String>>{
//         'Breakfast': <String>[],
//         'Lunch': <String>[],
//         'Snacks': <String>[],
//         'Dinner': <String>[],
//       },
//     };
//   }
//
//   void addMenu(){
//     String kitchenName = _kitchenNameController.text;
//     if(kitchenName.isEmpty){
//       _logger.e("Kitchen name is empty");
//       return;
//     }
//     currentMenu.kitchenName = kitchenName;
//     _logger.i("Adding $kitchenName to messMenus");
//     messMenus[kitchenName] = currentMenu;
//     clear();
//     notifyListeners();
//   }
//
//   void addMenuItem(){
//     String item = _itemNameController.text;
//     String weekday = this.weekday;
//     String mealType = this.mealType;
//     _logger.i("Adding $item to $weekday $mealType");
//     currentMenu.messMenu![weekday]![mealType]!.add(item);
//     _itemNameController.clear();
//     notifyListeners();
//   }
//
//   void removeMenuItem(int index){
//     String weekday = this.weekday;
//     String mealType = this.mealType;
//     _logger.i("Removing ${currentMenu.messMenu![weekday]![mealType]![index]} from $weekday $mealType");
//     currentMenu.messMenu![weekday]![mealType]!.removeAt(index);
//     notifyListeners();
//   }
//
// }

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/components/rounded_chip.dart';
import 'package:smart_insti_app/constants/dummy_entries.dart';
import 'package:smart_insti_app/models/mess_menu.dart';
import '../constants/constants.dart';
import 'dart:io';

final menuProvider = StateNotifierProvider<MenuStateNotifier, MenuState>((ref) => MenuStateNotifier());

class MenuStateNotifier extends StateNotifier<MenuState> {
  MenuStateNotifier()
      : super(MenuState(
          kitchenNameController: TextEditingController(),
          itemNameController: TextEditingController(),
          selectedViewMenu: DummyMenus.messMenus.keys.isNotEmpty ? DummyMenus.messMenus.keys.first : null,
          items: [],
          messMenus: DummyMenus.messMenus,
          currentMenu: MessMenu(
            messMenu: <String, Map<String, List<String>>>{
              'Sunday': <String, List<String>>{
                'Breakfast': <String>[],
                'Lunch': <String>[],
                'Snacks': <String>[],
                'Dinner': <String>[],
              },
              'Monday': <String, List<String>>{
                'Breakfast': <String>[],
                'Lunch': <String>[],
                'Snacks': <String>[],
                'Dinner': <String>[],
              },
              'Tuesday': <String, List<String>>{
                'Breakfast': <String>[],
                'Lunch': <String>[],
                'Snacks': <String>[],
                'Dinner': <String>[],
              },
              'Wednesday': <String, List<String>>{
                'Breakfast': <String>[],
                'Lunch': <String>[],
                'Snacks': <String>[],
                'Dinner': <String>[],
              },
              'Thursday': <String, List<String>>{
                'Breakfast': <String>[],
                'Lunch': <String>[],
                'Snacks': <String>[],
                'Dinner': <String>[],
              },
              'Friday': <String, List<String>>{
                'Breakfast': <String>[],
                'Lunch': <String>[],
                'Snacks': <String>[],
                'Dinner': <String>[],
              },
              'Saturday': <String, List<String>>{
                'Breakfast': <String>[],
                'Lunch': <String>[],
                'Snacks': <String>[],
                'Dinner': <String>[],
              },
            },
          ),
          selectedWeekdayIndex: 0,
          selectedMealTypeIndex: 0,
        ));

  final Logger _logger = Logger();

  String getWeekDay(int index) => MessMenuConstants.weekdaysShortToLong[MessMenuConstants.weekdays[index].data]!;

  String getMealType(int index) => MessMenuConstants.mealTypes[index].data!;

  void pickSpreadsheet() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      bool isSpreadsheet = result.files.single.path!.endsWith(".xlsx") ||
          result.files.single.path!.endsWith(".xls") ||
          result.files.single.path!.endsWith(".csv");
      if (isSpreadsheet) {
        File file = File(result.files.single.path!);

        // TODO : Add code to send the spreadsheet to the backend

        _logger.i("Picked file ${file.path}");
      } else {
        _logger.e("Picked file is not a spreadsheet");
      }
    } else {
      _logger.e("No file picked");
    }
  }

  void initMenu() {
    state = state.copyWith(
        currentMenu: MessMenu(
      messMenu: <String, Map<String, List<String>>>{
        'Sunday': <String, List<String>>{
          'Breakfast': <String>[],
          'Lunch': <String>[],
          'Snacks': <String>[],
          'Dinner': <String>[],
        },
        'Monday': <String, List<String>>{
          'Breakfast': <String>[],
          'Lunch': <String>[],
          'Snacks': <String>[],
          'Dinner': <String>[],
        },
        'Tuesday': <String, List<String>>{
          'Breakfast': <String>[],
          'Lunch': <String>[],
          'Snacks': <String>[],
          'Dinner': <String>[],
        },
        'Wednesday': <String, List<String>>{
          'Breakfast': <String>[],
          'Lunch': <String>[],
          'Snacks': <String>[],
          'Dinner': <String>[],
        },
        'Thursday': <String, List<String>>{
          'Breakfast': <String>[],
          'Lunch': <String>[],
          'Snacks': <String>[],
          'Dinner': <String>[],
        },
        'Friday': <String, List<String>>{
          'Breakfast': <String>[],
          'Lunch': <String>[],
          'Snacks': <String>[],
          'Dinner': <String>[],
        },
        'Saturday': <String, List<String>>{
          'Breakfast': <String>[],
          'Lunch': <String>[],
          'Snacks': <String>[],
          'Dinner': <String>[],
        },
      },
    ));
  }

  void setSelectViewMenu(String? value) {
    state = state.copyWith(selectedViewMenu: value);
  }

  void selectWeekday(int index) {
    state = state.copyWith(selectedWeekdayIndex: index);
  }

  void selectMealType(int index) {
    state = state.copyWith(selectedMealTypeIndex: index);
  }

  void clear() {
    state = state.copyWith(
      items: [],
      currentMenu: MessMenu(
        messMenu: <String, Map<String, List<String>>>{
          'Sunday': <String, List<String>>{
            'Breakfast': <String>[],
            'Lunch': <String>[],
            'Snacks': <String>[],
            'Dinner': <String>[],
          },
          'Monday': <String, List<String>>{
            'Breakfast': <String>[],
            'Lunch': <String>[],
            'Snacks': <String>[],
            'Dinner': <String>[],
          },
          'Tuesday': <String, List<String>>{
            'Breakfast': <String>[],
            'Lunch': <String>[],
            'Snacks': <String>[],
            'Dinner': <String>[],
          },
          'Wednesday': <String, List<String>>{
            'Breakfast': <String>[],
            'Lunch': <String>[],
            'Snacks': <String>[],
            'Dinner': <String>[],
          },
          'Thursday': <String, List<String>>{
            'Breakfast': <String>[],
            'Lunch': <String>[],
            'Snacks': <String>[],
            'Dinner': <String>[],
          },
          'Friday': <String, List<String>>{
            'Breakfast': <String>[],
            'Lunch': <String>[],
            'Snacks': <String>[],
            'Dinner': <String>[],
          },
          'Saturday': <String, List<String>>{
            'Breakfast': <String>[],
            'Lunch': <String>[],
            'Snacks': <String>[],
            'Dinner': <String>[],
          },
        },
      ),
    );
  }

  void addMenu() {
    String kitchenName = state.kitchenNameController.text;
    if (kitchenName.isEmpty) {
      _logger.e("Kitchen name is empty");
      return;
    }
    _logger.i("Adding $kitchenName to messMenus");

    Map<String, MessMenu> menuList = state.messMenus;
    menuList[kitchenName] = state.currentMenu;

    state = state.copyWith(
      currentMenu: MessMenu(kitchenName: kitchenName, messMenu: state.currentMenu.messMenu),
      messMenus: menuList,
      kitchenNameController: TextEditingController(),
    );
    clear();
  }

  void addMenuItem() {
    String item = state.itemNameController.text;
    String weekday = getWeekDay(state.selectedWeekdayIndex);
    String mealType = getMealType(state.selectedMealTypeIndex);
    _logger.i("Adding $item to $weekday $getMealType");

    MessMenu menu = state.currentMenu;
    menu.messMenu![weekday]![mealType]!.add(item);

    state = state.copyWith(currentMenu: menu);
    state.itemNameController.clear();
  }

  void removeMenuItem(int index) {
    String weekday = getWeekDay(state.selectedWeekdayIndex);
    String mealType = getMealType(state.selectedMealTypeIndex);
    _logger.i("Removing ${state.currentMenu.messMenu![weekday]![mealType]![index]} from $weekday $mealType");
    MessMenu menu = state.currentMenu;
    menu.messMenu![weekday]![mealType]!.removeAt(index);
    state = state.copyWith(currentMenu: menu);
  }
}

class MenuState {
  final TextEditingController kitchenNameController;
  final TextEditingController itemNameController;
  final String? selectedViewMenu;
  final List<RoundedChip> items;
  final Map<String, MessMenu> messMenus;
  final MessMenu currentMenu;
  final int selectedWeekdayIndex;
  final int selectedMealTypeIndex;

  MenuState({
    required this.kitchenNameController,
    required this.itemNameController,
    required this.selectedViewMenu,
    required this.items,
    required this.messMenus,
    required this.currentMenu,
    required this.selectedWeekdayIndex,
    required this.selectedMealTypeIndex,
  });

  MenuState copyWith({
    TextEditingController? kitchenNameController,
    TextEditingController? itemNameController,
    String? selectedViewMenu,
    List<RoundedChip>? items,
    Map<String, MessMenu>? messMenus,
    MessMenu? currentMenu,
    int? selectedWeekdayIndex,
    int? selectedMealTypeIndex,
  }) {
    return MenuState(
      kitchenNameController: kitchenNameController ?? this.kitchenNameController,
      itemNameController: itemNameController ?? this.itemNameController,
      selectedViewMenu: selectedViewMenu ?? this.selectedViewMenu,
      items: items ?? this.items,
      messMenus: messMenus ?? this.messMenus,
      currentMenu: currentMenu ?? this.currentMenu,
      selectedWeekdayIndex: selectedWeekdayIndex ?? this.selectedWeekdayIndex,
      selectedMealTypeIndex: selectedMealTypeIndex ?? this.selectedMealTypeIndex,
    );
  }
}
