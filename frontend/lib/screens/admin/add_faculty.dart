import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../components/text_divider.dart';

class AddFaculty extends StatelessWidget {
  AddFaculty({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
        width: 411,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Faculty'),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 30),
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
                    child: Column(

                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
