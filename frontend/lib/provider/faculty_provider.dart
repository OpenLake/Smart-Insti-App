import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/dummy_entries.dart';
import '../models/course.dart';
import '../models/faculty.dart';
import 'dart:io';


class FacultyProvider extends ChangeNotifier{

  final TextEditingController _facultyNameController = TextEditingController();
  final TextEditingController _facultyEmailController = TextEditingController();
  final TextEditingController _searchFacultyController = TextEditingController();

  TextEditingController get facultyNameController => _facultyNameController;
  TextEditingController get facultyEmailController => _facultyEmailController;
  TextEditingController get searchFacultyController => _searchFacultyController;

  final Logger _logger = Logger();


  List<Course> selectedCourses = [];

  List<Faculty> faculties = DummyFaculties.faculties;
  List<Faculty> filteredFaculties = [];

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

  void addFaculty(){
    Faculty faculty = Faculty(
      name: _facultyNameController.text,
      facultyMail: _facultyEmailController.text,
      courses: selectedCourses,
    );
    _logger.i("Added faculty: ${faculty.name}");
    faculties.add(faculty);
    _facultyNameController.clear();
    _facultyEmailController.clear();
    selectedCourses.clear();
    notifyListeners();
  }

  void searchFaculties(){
    String query = _searchFacultyController.text;
    _logger.i("Searching for faculty: $query");
    filteredFaculties = faculties.where((faculty) => faculty.name.toLowerCase().contains(query.toLowerCase())).toList();
    notifyListeners();
  }

  void removeFaculty(Faculty faculty){
    faculties.remove(faculty);
    _logger.i("Removed faculty: ${faculty.name}");
    String query = _searchFacultyController.text;
    filteredFaculties = faculties.where((faculty) => faculty.name.toLowerCase().contains(query.toLowerCase())).toList();
    notifyListeners();
  }

}