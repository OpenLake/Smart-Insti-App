import 'package:flutter/material.dart';

class AppConstants{
  static const String appName = "Smart Insti App";
  static const Color seedColor = Colors.lightBlueAccent;
}

class Branches {
  static List<DropdownMenuItem<String>> branchList = const [
    DropdownMenuItem<String>(value: "Computer Science and Engineering", child: Text("Computer Science and Engineering")),
    DropdownMenuItem<String>(value: "Computer Science", child: Text("Computer Science")),
    DropdownMenuItem<String>(value: "Electrical Engineering", child: Text("Electrical Engineering")),
    DropdownMenuItem<String>(value: "Mechanical Engineering", child: Text("Mechanical Engineering")),
    DropdownMenuItem<String>(value: "Civil Engineering", child: Text("Civil Engineering")),
    DropdownMenuItem<String>(value: "Chemical Engineering", child: Text("Chemical Engineering")),
    DropdownMenuItem<String>(value: "Aerospace Engineering", child: Text("Aerospace Engineering")),
    DropdownMenuItem<String>(value: "Metallurgical Engineering", child: Text("Metallurgical Engineering")),
    DropdownMenuItem<String>(value: "Ocean Engineering", child: Text("Ocean Engineering")),
    DropdownMenuItem<String>(value: "Biotechnology", child: Text("Biotechnology")),
    DropdownMenuItem<String>(value: "Physics", child: Text("Physics")),
    DropdownMenuItem<String>(value: "Chemistry", child: Text("Chemistry")),
    DropdownMenuItem<String>(value: "Mathematics", child: Text("Mathematics")),
    DropdownMenuItem<String>(value: "Humanities and Social Sciences", child: Text("Humanities and Social Sciences")),
    DropdownMenuItem<String>(value: "Management Studies", child: Text("Management Studies")),
    DropdownMenuItem<String>(value: "Nanotechnology", child: Text("Nanotechnology")),
    DropdownMenuItem<String>(value: "Energy Engineering", child: Text("Energy Engineering")),
    DropdownMenuItem<String>(value: "Environmental Engineering", child: Text("Environmental Engineering")),
    DropdownMenuItem<String>(
        value: "Industrial Engineering and Operations Research",
        child: Text("Industrial Engineering and Operations Research")),
    DropdownMenuItem<String>(value: "Systems and Control Engineering", child: Text("Systems and Control Engineering")),
    DropdownMenuItem<String>(
        value: "Materials Science and Engineering", child: Text("Materials Science and Engineering")),
  ];
}

class LayoutConstants{

}

class Validators{
  static String? emailValidator(String? value){
    if(value == null || value.isEmpty){
      return "Email cannot be empty";
    }
    if(!EmailValidator.validate(value)){
      return "Invalid email";
    }
    return null;
  }

  static String? branchValidator(String? value){
    if(value == null || value.isEmpty){
      return "Branch cannot be empty";
    }
    return null;
  }

  static String? nameValidator(String? value){
    if(value == null || value.isEmpty){
      return "Name cannot be empty";
    }
    return null;
  }

  static String? rollNumberValidator(String? value){
    if(value == null || value.isEmpty){
      return "Roll Number cannot be empty";
    }
    if(value.contains(r"!@#%^&*()_+{}||:<>?/.,$")){
      return "Invalid Roll Number";
    }
    return null;
  }

  static String? courseCodeValidator(String? value){
    if(value == null || value.isEmpty){
      return "Course Code cannot be empty";
    }
    if(value.contains(r"!@#%^&*()_+{}||:<>?/.,$")){
      return "Invalid Course Code";
    }
    return null;
  }
}