import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:search_choices/search_choices.dart';
import 'package:smart_insti_app/components/text_divider.dart';

class AddStudents extends StatelessWidget {
  AddStudents({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 30),


                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter student name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(20),
                            hintText: "Enter Name",
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
                              return 'Please enter student roll number';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Roll Number",
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
                          decoration: InputDecoration(
                            hintText: "Enter Student Mail",
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
                          decoration: InputDecoration(
                            hintText: "Enter Phone Number",
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
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.tealAccent.withOpacity(0.4),
                          ),
                          child: SearchChoices.single(
                            style: TextStyle(
                              color: Colors.teal.shade900,
                              fontSize: 15,
                              fontFamily: "RobotoFlex",
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: "Computer Science",
                                  child: Text("Computer Science")),
                              DropdownMenuItem(
                                  value: "Electrical Engineering",
                                  child: Text("Electrical Engineering")),
                              DropdownMenuItem(
                                  value: "Mechanical Engineering",
                                  child: Text("Mechanical Engineering")),
                            ],
                            value: "Computer Science",
                            hint: "Select one",
                            searchHint: null,
                            onChanged: (value) {},
                            dialogBox: false,
                            isExpanded: true,
                            menuConstraints: BoxConstraints.tight(
                                const Size.fromHeight(350)),
                            menuBackgroundColor: Colors.tealAccent.shade100,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.tealAccent.withOpacity(0.4),
                          ),
                          child: SearchChoices.single(
                            style: TextStyle(
                              color: Colors.teal.shade900,
                              fontSize: 15,
                              fontFamily: "RobotoFlex",
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: "Hostel A",
                                child: Text("Hostel A"),
                              ),
                              DropdownMenuItem(
                                value: "Hostel B",
                                child: Text("Hostel B"),
                              ),
                              DropdownMenuItem(
                                value: "Hostel C",
                                child: Text("Hostel C"),
                              ),
                            ],
                            value: "Hostel A",
                            hint: "Select one",
                            searchHint: null,
                            onChanged: (value) {},
                            dialogBox: false,
                            isExpanded: true,
                            menuConstraints: BoxConstraints.tight(
                                const Size.fromHeight(350)),
                            menuBackgroundColor: Colors.tealAccent.shade100,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Select Year"),
                                content: SizedBox(
                                  width: 300,
                                  height: 300,
                                  child: YearPicker(
                                    firstDate: DateTime(DateTime.now().year),
                                    lastDate:
                                        DateTime(DateTime.now().year + 10),
                                    selectedDate: DateTime.now(),
                                    onChanged: (value) {
                                      context.pop();
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                            minimumSize: MaterialStateProperty.all(
                              const Size.fromHeight(60),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month),
                                const SizedBox(width: 10),
                                Text(
                                    "Graduation Year : ${DateTime.now().year}"),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              _formKey.currentState!.validate();
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size(200, 60))),
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
