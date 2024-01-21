import 'package:flutter/material.dart';

class AppConstants{
  static const String appName = "Smart Insti App";
  static const Color seedColor = Colors.lightBlueAccent;
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