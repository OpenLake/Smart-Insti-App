import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_scaled_box.dart';
import 'package:smart_insti_app/provider/faculty_provider.dart';

import '../../models/faculty.dart';

class ViewFaculty extends StatelessWidget {
  const ViewFaculty({super.key});

  @override
  Widget build(BuildContext context) {
    FacultyProvider facultyProvider = Provider.of<FacultyProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      facultyProvider.searchFaculties();
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
                  controller: facultyProvider.searchFacultyController,
                  hintText: 'Enter faculty name',
                  onChanged: (value) {
                    facultyProvider.searchFaculties();
                  },
                  onSubmitted: (value) {
                    facultyProvider.searchFaculties();
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
        body: Consumer<FacultyProvider>(
          builder: (_, coursesProvider, ___) {
            if (coursesProvider.filteredFaculties.isEmpty) {
              return const Center(
                child: Text(
                  'No Courses so far',
                  style: TextStyle(fontSize: 30, color: Colors.black38),
                ),
              );
            }
            return ListView.builder(
                itemBuilder: (_, index) {
                  List<Faculty> faculties = coursesProvider.filteredFaculties;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ListTile(
                      tileColor: Colors.grey.shade200,
                      selectedTileColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      title: Text('Faculty : ${faculties[index].name}'),
                      subtitle: Text('Faculty Email : ${faculties[index].facultyMail}'),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              iconSize: 20,
                              icon: const Icon(Icons.edit),
                              onPressed: () =>  showDialog(
                                context: context,
                                builder: (_) => const AlertDialog(
                                  title: Text('Edit Faculty'),
                                  content: Text("Faculty editing will be added in future"),
                                ),
                              ),
                            ),
                            IconButton(
                              iconSize: 20,
                              icon: const Icon(Icons.delete),
                              onPressed: () => coursesProvider.removeFaculty(faculties[index]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: coursesProvider.filteredFaculties.length);
          },
        ),
      ),
    );
  }
}
