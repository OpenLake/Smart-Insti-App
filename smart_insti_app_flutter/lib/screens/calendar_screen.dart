import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class CalendarScreen extends StatelessWidget {
  static String id = 'calendar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar')),
      drawer: AppDrawer(),
      body: Center(
        child: Text('This is Calendar Screen'),
      ),
    );
  }
}
