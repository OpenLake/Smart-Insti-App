import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/components/multiple_choice_selector.dart';
import 'package:smart_insti_app/provider/room_provider.dart';
import '../../components/choice_selector.dart';
import '../../components/text_divider.dart';
import '../../constants/constants.dart';
import '../../provider/auth_provider.dart';
import '../../provider/courses_provider.dart';

class AddCourses extends ConsumerWidget {
  AddCourses({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider.notifier).tokenCheckProgress != LoadingState.progress) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(context, AuthConstants.adminAuthLabel.toLowerCase());
      }
    });
    final course = ref.watch(coursesProvider);
    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Courses'),
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
                        onPressed: () => ref.read(coursesProvider.notifier).pickSpreadsheet(),
                        style: ButtonStyle(minimumSize: MaterialStateProperty.all(const Size(200, 60))),
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
                          controller: course.courseNameController,
                          validator: (value) => Validators.nameValidator(value),
                          hintText: "Enter course name",
                          hintColor: Colors.teal.shade900.withOpacity(0.5),
                        ),
                        const SizedBox(height: 30),
                        MaterialTextFormField(
                          controller: course.courseCodeController,
                          validator: (value) => Validators.courseCodeValidator(value),
                          hintText: "Enter course code",
                          hintColor: Colors.teal.shade900.withOpacity(0.5),
                        ),
                        const SizedBox(height: 30),
                        MaterialTextFormField(
                          hintText: "Credits",
                          hintColor: Colors.teal.shade900.withOpacity(0.5),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          controller: course.courseCreditController,
                        ),
                        const SizedBox(height: 30),
                        Consumer(
                          builder: (_, ref, __) => ChoiceSelector(
                            hint: "Primary room",
                            onChanged: (value) => ref.read(coursesProvider.notifier).updatePrimaryRoom(value),
                            value: ref.read(coursesProvider).primaryRoom,
                            items: ref
                                .watch(roomProvider)
                                .roomList
                                .map(
                                  (room) => DropdownMenuItem(
                                    value: room.name,
                                    child: Text(room.name),
                                  ),
                                )
                                .toList(),
                            addItemEnabled: false,
                          ),
                        ),
                        const SizedBox(height: 30),
                        MultipleChoiceSelector(
                          hint: "Choose course branches",
                          onChanged: (value) => ref.read(coursesProvider.notifier).updateBranch(value),
                          items: ref.read(coursesProvider).selectableBranches,
                          addSelectableItem: (value) => ref.read(coursesProvider.notifier).addSelectableBranch(value),
                          selectedItems: ref.read(coursesProvider).branches,
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ref.read(coursesProvider.notifier).addCourse();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Added Course')),
                                );
                              }
                            },
                            style: ButtonStyle(minimumSize: MaterialStateProperty.all(const Size(200, 60))),
                            child: const Text("Add Course"),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
