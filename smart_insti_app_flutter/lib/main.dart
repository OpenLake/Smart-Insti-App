import 'package:flutter/material.dart';
import 'package:smart_insti_app_flutter/screens/calendar_screen.dart';
import 'package:smart_insti_app_flutter/screens/feed_screen.dart';
import 'package:smart_insti_app_flutter/widgets/app_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: FeedScreen.id,
      routes: {
        FeedScreen.id: (context) => FeedScreen(),
        CalendarScreen.id: (context) => CalendarScreen(),
      },
    );
  }
}
