import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_scaled_box.dart';


class ViewCourses extends StatelessWidget {
  const ViewCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: 390,
                child: SearchBar(
                  hintText: 'Enter course code',
                  leading:  IconButton(icon:const Icon(Icons.arrow_back),onPressed: () => context.pop(),),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
            )
          ],
        ),
        body: const Center(
          child: Text('View Courses'),
        ),
      ),
    );
  }
}
