import 'package:flutter/material.dart';


class MenuProvider extends ChangeNotifier {

  String weekDay = 'Sun';
  
  void setWeekDay(String day){
    weekDay = day;
    notifyListeners();
  }
}