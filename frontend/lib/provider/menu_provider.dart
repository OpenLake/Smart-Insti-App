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

  void initMenuView() {
    final selectedViewMenu = DummyMenus.messMenus.keys.isNotEmpty ? DummyMenus.messMenus.keys.first : null;

    state = state.copyWith(
      selectedMealTypeIndex: 0,
      selectedWeekdayIndex: 0,
      selectedViewMenu: selectedViewMenu,
    );
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

    state.kitchenNameController.clear();

    state = state.copyWith(
      currentMenu: MessMenu(messMenu: {...MessMenuConstants.emptyMenu}),
      messMenus: menuList,
      items: [],
    );
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
