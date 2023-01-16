import 'package:flutter/material.dart';

class TextStyles{

  static TextStyle title = const 
    TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.black
    );
  static TextStyle titleLight = const 
    TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.white
    );
  static TextStyle subtitle = const
      TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color.fromARGB(200, 00, 00, 00)
      );
  static TextStyle subtitleLight = const
      TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color.fromARGB(200, 255, 255, 255)
      );
  static TextStyle boldCount = const
      TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: Colors.black
      );
}
