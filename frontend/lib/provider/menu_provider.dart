import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/components/rounded_chip.dart';
import 'package:smart_insti_app/constants/dummy_entries.dart';
import 'package:smart_insti_app/models/mess_menu.dart';
import '../constants/constants.dart';
import 'dart:io';


class MenuProvider extends ChangeNotifier {

  final TextEditingController _kitchenNameController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  String? selectedViewMenu;

  TextEditingController get kitchenNameController => _kitchenNameController;
  TextEditingController get itemNameController => _itemNameController;

  final List<RoundedChip> items = [];
  final Map<String,MessMenu> messMenus = DummyMenus.messMenus;
  late MessMenu currentMenu;
  final Logger _logger = Logger();

  int selectedWeekdayIndex = 0;
  int selectedMealTypeIndex = 0;

  get weekday => MessMenuConstants.weekdaysShortToLong[MessMenuConstants.weekdays[selectedWeekdayIndex].data];
  get mealType => MessMenuConstants.mealTypes[selectedMealTypeIndex].data;

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

  void setSelectViewMenu(String? value){
    selectedViewMenu = value;
    notifyListeners();
  }

  void selectWeekday(int index) {
    selectedWeekdayIndex = index;
    notifyListeners();
  }

  void selectMealType(int index) {
    selectedMealTypeIndex = index;
    notifyListeners();
  }

  void clear() {
    _kitchenNameController.clear();
    _itemNameController.clear();
    items.clear();
    initMenu();
    selectedWeekdayIndex = 0;
    selectedMealTypeIndex = 0;
    notifyListeners();
  }

  
  void initMenu(){
    currentMenu = MessMenu();
    currentMenu.messMenu = <String, Map<String, List<String>>>{
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
    };
  }

  void addMenu(){
    String kitchenName = _kitchenNameController.text;
    if(kitchenName.isEmpty){
      _logger.e("Kitchen name is empty");
      return;
    }
    currentMenu.kitchenName = kitchenName;
    _logger.i("Adding $kitchenName to messMenus");
    messMenus[kitchenName] = currentMenu;
    clear();
    notifyListeners();
  }

  void addMenuItem(){
    String item = _itemNameController.text;
    String weekday = this.weekday;
    String mealType = this.mealType;
    _logger.i("Adding $item to $weekday $mealType");
    currentMenu.messMenu![weekday]![mealType]!.add(item);
    _itemNameController.clear();
    notifyListeners();
  }

  void removeMenuItem(int index){
    String weekday = this.weekday;
    String mealType = this.mealType;
    _logger.i("Removing ${currentMenu.messMenu![weekday]![mealType]![index]} from $weekday $mealType");
    currentMenu.messMenu![weekday]![mealType]!.removeAt(index);
    notifyListeners();
  }

}