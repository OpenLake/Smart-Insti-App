import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LostAndFound extends StatelessWidget {
  const LostAndFound({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Lost & Found'),
          ),
          body: const Center(
            child: Text('Lost & Found'),
          )),
    );
  }
}
