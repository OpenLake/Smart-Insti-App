import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_scaled_box.dart';
import 'package:smart_insti_app/provider/courses_provider.dart';

import '../../models/course.dart';

class ViewCourses extends StatelessWidget {
  const ViewCourses({super.key});

  @override
  Widget build(BuildContext context) {
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      coursesProvider.searchCourses();
    });

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
                  controller: coursesProvider.searchCourseController,
                  hintText: 'Enter course code',
                  onChanged: (value) {
                    coursesProvider.searchCourses();
                  },
                  onSubmitted: (value) {
                    coursesProvider.searchCourses();
                  },
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
            )
          ],
        ),
        body: Consumer<CoursesProvider>(
          builder: (_, coursesProvider, ___) {
            if (coursesProvider.filteredCourses.isEmpty) {
              return const Center(
                child: Text(
                  'No Courses so far',
                  style: TextStyle(fontSize: 30, color: Colors.black38),
                ),
              );
            }
            return ListView.builder(
                itemBuilder: (_, index) {
                  List<Course> courses = coursesProvider.filteredCourses;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ListTile(
                      tileColor: Colors.grey.shade200,
                      selectedTileColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      title: Text('Course ${courses[index].courseName}'),
                      subtitle: Text('Course Code : ${courses[index].courseCode}'),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              iconSize: 20,
                              icon: const Icon(Icons.edit),
                              onPressed: () {},
                            ),
                            IconButton(
                              iconSize: 20,
                              icon: const Icon(Icons.delete),
                              onPressed: () => coursesProvider.removeCourse(courses[index]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: coursesProvider.filteredCourses.length);
          },
        ),
      ),
    );
  }
}
