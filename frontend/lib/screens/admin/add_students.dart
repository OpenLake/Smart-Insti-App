import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/components/choice_selector.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/components/text_divider.dart';
import 'package:smart_insti_app/constants/constants.dart';
import 'package:smart_insti_app/provider/student_provider.dart';

class AddStudents extends StatelessWidget {
  AddStudents({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    StudentProvider studentProvider = Provider.of<StudentProvider>(context, listen: false);
    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Students"),
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
                        onPressed: () => studentProvider.pickSpreadsheet(),
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
                          controller: studentProvider.studentNameController,
                          validator: (value) => Validators.nameValidator(value),
                          hintText: "Enter Student Name",
                          hintColor: Colors.teal.shade900.withOpacity(0.5),
                        ),
                        const SizedBox(height: 30),
                        MaterialTextFormField(
                          controller: studentProvider.studentRollNoController,
                          validator: (value) => Validators.rollNumberValidator(value),
                          hintText: "Enter Roll Number",
                          hintColor: Colors.teal.shade900.withOpacity(0.5),
                        ),
                        const SizedBox(height: 30),
                        MaterialTextFormField(
                          controller: studentProvider.studentEmailController,
                          validator: (value) => Validators.emailValidator(value),
                          hintText: "Enter Student Mail",
                          hintColor: Colors.teal.shade900.withOpacity(0.5),
                        ),
                        const SizedBox(height: 30),
                        ChoiceSelector(
                          onChanged: (value) => studentProvider.branch = value!,
                          value: studentProvider.branch,
                          items: Branches.branchList,
                          hint: "Select Branch",
                        ),
                        const SizedBox(height: 30),
                        ChoiceSelector(
                          onChanged: (value) => studentProvider.role = value!,
                          value: studentProvider.role,
                          items: StudentRoles.studentRoleList,
                          hint: "Select student role",
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                studentProvider.addStudent();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Added Student')),
                                );
                              }
                            },
                            style: ButtonStyle(minimumSize: MaterialStateProperty.all(const Size(200, 60))),
                            child: const Text("Add Student"),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
