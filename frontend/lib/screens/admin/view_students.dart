import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/provider/student_provider.dart';

import '../../models/student.dart';

class ViewStudents extends StatelessWidget {
  const ViewStudents({super.key});

  @override
  Widget build(BuildContext context) {
    StudentProvider studentProvider = Provider.of<StudentProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      studentProvider.searchStudents();
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
                  controller: studentProvider.searchStudentController,
                  hintText: 'Enter student name',
                  onChanged: (value) {
                    studentProvider.searchStudents();
                  },
                  onSubmitted: (value) {
                    studentProvider.searchStudents();
                  },
                  leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        studentProvider.searchStudentController.clear();
                        context.pop();
                      }),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
            )
          ],
        ),
        body: Consumer<StudentProvider>(
          builder: (_, coursesProvider, ___) {
            if (coursesProvider.filteredStudents.isEmpty) {
              return const Center(
                child: Text(
                  'No students so far',
                  style: TextStyle(fontSize: 30, color: Colors.black38),
                ),
              );
            }
            return ListView.builder(
                itemBuilder: (_, index) {
                  List<Student> students = coursesProvider.filteredStudents;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ListTile(
                      tileColor: Colors.grey.shade200,
                      selectedTileColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      title: Text('Name ${students[index].name}'),
                      subtitle: Text('Roll Number : ${students[index].rollNumber}'),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              iconSize: 20,
                              icon: const Icon(Icons.edit),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (_) => const AlertDialog(
                                  title: Text('Edit Student'),
                                  content: Text("Student editing will be added in future"),
                                ),
                              ),
                            ),
                            IconButton(
                              iconSize: 20,
                              icon: const Icon(Icons.delete),
                              onPressed: () => coursesProvider.removeStudent(students[index]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: coursesProvider.filteredStudents.length);
          },
        ),
      ),
    );
  }
}
