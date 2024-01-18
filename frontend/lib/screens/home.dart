import 'package:flutter/material.dart';
import '../constants/constants.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppConstants.appName),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: const Center(
          child: Text(AppConstants.appName),
        ),
      ),
    );
  }
}
