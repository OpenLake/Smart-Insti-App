import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:slide_switcher/slide_switcher.dart';

import '../../components/text_divider.dart';
import '../../provider/menu_provider.dart';

class AddMessMenu extends StatelessWidget {
  const AddMessMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Mess Menu'),
        ),
        body: SingleChildScrollView(
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
                      onPressed: () => {},
                      style: ButtonStyle(minimumSize: MaterialStateProperty.all(const Size(200, 60))),
                      child: const Text("Upload Spreadsheet"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const TextDivider(text: "OR"),
              const SizedBox(height: 30),
              SlideSwitcher(
                onSelect: (index) {},
                containerHeight: 70,
                containerWight: 390,
                slidersColors: [Colors.greenAccent],
                containerColor: Colors.grey.shade300,
                children: [
                  Container(width: 70, child: Text('Breakfast')),
                  Text('Lunch'),
                  Text('Snacks'),
                  Text('Dinner'),
                ],
              ),
              Consumer<MenuProvider>(
                builder: (_, menuProvider, ___) {
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 15, top: 30),
                        child: SlideSwitcher(
                          onSelect: (index) {},
                          containerHeight: 550,
                          containerWight: 70,
                          containerBorderRadius: 20,
                          direction: Axis.vertical,
                          slidersColors: [Colors.tealAccent.shade700.withOpacity(0.7)],
                          containerColor: Colors.tealAccent.shade100,
                          children: [
                            Text('Sun', style: TextStyle(color: Colors.teal.shade900,fontSize: 16)),
                            Text('Mon', style: TextStyle(color: Colors.teal.shade900,fontSize: 16)),
                            Text('Tue', style: TextStyle(color: Colors.teal.shade900,fontSize: 16)),
                            Text('Wed', style: TextStyle(color: Colors.teal.shade900,fontSize: 16)),
                            Text('Thu', style: TextStyle(color: Colors.teal.shade900,fontSize: 16)),
                            Text('Fri', style: TextStyle(color: Colors.teal.shade900,fontSize: 16)),
                            Text('Sat', style: TextStyle(color: Colors.teal.shade900,fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30)
                    ],
                  );
                },
              ), // many more parameters available
            ],
          ),
        ),
      ),
    );
  }
}
