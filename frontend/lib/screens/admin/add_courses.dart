import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../components/text_divider.dart';

class AddCourses extends StatelessWidget {
  AddCourses({super.key});

  final _formKey = GlobalKey<FormState>();
  final List<Chip> majors = [

  ];

  final List<Color> chipColors =[
    Colors.redAccent.shade100,
    Colors.redAccent.shade200,
    Colors.greenAccent.shade100,
    Colors.greenAccent.shade200,
    Colors.yellowAccent.shade100,
    Colors.yellowAccent.shade200,
    Colors.lightBlueAccent.shade100,
    Colors.lightBlueAccent.shade200,
    Colors.purpleAccent.shade100,
    Colors.purpleAccent.shade200,
  ];

  @override
  Widget build(BuildContext context) {
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
                        onPressed: () {},
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
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter course name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(20),
                            hintText: "Enter course name",
                            filled: true,
                            hintStyle: TextStyle(
                              color: Colors.teal.shade900,
                              fontSize: 15,
                              fontFamily: "RobotoFlex",
                            ),
                            fillColor: Colors.tealAccent.withOpacity(0.4),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please student name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(20),
                            hintText: "Enter course code",
                            filled: true,
                            hintStyle: TextStyle(
                              color: Colors.teal.shade900,
                              fontSize: 15,
                              fontFamily: "RobotoFlex",
                            ),
                            fillColor: Colors.tealAccent.withOpacity(0.4),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter course code';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            majors.add(
                              Chip(
                                backgroundColor: chipColors[majors.length % 10],
                                onDeleted: () {
                                  majors.removeWhere((element) =>
                                      element.label.toString() == value);
                                },
                                label: Text(value),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            );
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(20),
                            hintText: "Enter majors / branches",
                            filled: true,
                            hintStyle: TextStyle(
                              color: Colors.teal.shade900,
                              fontSize: 15,
                              fontFamily: "RobotoFlex",
                            ),
                            fillColor: Colors.tealAccent.withOpacity(0.4),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        for (Chip i in majors)
                          Align(alignment: Alignment.centerLeft, child: i),
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
