import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/components/multiple_choice_selector.dart';
import 'package:smart_insti_app/provider/courses_provider.dart';
import '../../components/text_divider.dart';
import '../../constants/constants.dart';
import '../../provider/auth_provider.dart';
import '../../provider/faculty_provider.dart';

class AddFaculty extends ConsumerWidget {
  AddFaculty({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider.notifier).tokenCheckProgress != LoadingState.progress) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(context, AuthConstants.adminAuthLabel.toLowerCase());
      }
    });
    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Faculty'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 30),
                  child: const Text(
                    "Spreadsheet Entry",
                    style: TextStyle(fontSize: 32, fontFamily: "RobotoFlex"),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Upload file here",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(facultyProvider.notifier)
                            .pickSpreadsheet(),
                        style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all(const Size(200, 60))),
                        child: const Text("Upload Spreadsheet"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const TextDivider(text: "OR"),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 30),
                  child: const Text(
                    "Single Entry",
                    style: TextStyle(fontSize: 32, fontFamily: "RobotoFlex"),
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        MaterialTextFormField(
                          controller: ref.read(facultyProvider).facultyNameController,
                          validator: (value) => Validators.nameValidator(value),
                          hintText: 'Faculty Name',
                          hintColor: Colors.teal.shade900.withOpacity(0.5),
                        ),
                        const SizedBox(height: 30),
                        MaterialTextFormField(
                          controller: ref.read(facultyProvider).facultyEmailController,
                          validator: (value) => Validators.emailValidator(value),
                          hintText: 'Faculty Mail',
                          hintColor: Colors.teal.shade900.withOpacity(0.5),
                        ),
                        const SizedBox(height: 30),
                        MaterialTextFormField(
                          hintText: "Cabin",
                          controller: ref.read(facultyProvider).facultyCabinController,
                          hintColor: Colors.teal.shade900.withOpacity(0.5),
                        ),
                        const SizedBox(height: 30),
                        MaterialTextFormField(
                          hintText: "Department",
                          controller: ref.read(facultyProvider).facultyDepartmentController,
                          hintColor: Colors.teal.shade900.withOpacity(0.5),
                        ),
                        const SizedBox(height: 30),
                        Consumer(
                          builder: (_, ref, __) => MultipleChoiceSelector(
                            addItemEnabled: false,
                            hint: "Courses taught",
                            onChanged: (value) => ref.read(facultyProvider.notifier).updateSelectedCourses(value),
                            items: ref
                                .watch(coursesProvider)
                                .courses
                                .map((course) => DropdownMenuItem(
                                      value: course.id,
                                      child: Text("${course.courseCode} - ${course.courseName}"),
                                    ))
                                .toList(),
                            selectedItems: ref.watch(facultyProvider).selectedCourses,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ref.read(facultyProvider.notifier).addFaculty();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added Faculty')),
                        );
                      }
                    },
                    style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(200, 60))),
                    child: const Text("Add Faculty"),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
