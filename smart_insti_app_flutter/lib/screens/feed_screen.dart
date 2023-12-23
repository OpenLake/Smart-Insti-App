import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class FeedScreen extends StatelessWidget {
  static String id = 'feed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feed')),
      drawer: AppDrawer(),
      body: Center(child:Text('This is the section for feed'),),
    );
  }
}
