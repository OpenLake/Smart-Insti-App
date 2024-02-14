import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/components/borderless_button.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';

class Timetables extends StatelessWidget {
  const Timetables({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Time Tables'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                content: const SizedBox(
                  width: 300,
                  height: 250,
                  child: Column(
                    children: [
                      Text(
                        'Add Time Table',
                        style: TextStyle(fontSize: 28),
                      ),
                      SizedBox(height: 20),
                      MaterialTextFormField(hintText: "Timetable name"),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            child: MaterialTextFormField(hintText: "7"),
                            width: 100,
                          ),
                          Text('X'),
                          SizedBox(
                            child: MaterialTextFormField(hintText: ""),
                            width: 100,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                actions: [
                  BorderlessButton(
                    onPressed: () => context.push('/user_home/timetables/editor'),
                    label: const Text('Add'),
                    backgroundColor: Colors.green.shade100,
                    splashColor: Colors.green.shade700,
                  ),
                ],
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) {
            return OutlinedButton(
              onPressed: () {
                // context.push('/user_home/room_vacancy');
              },
              child: ListTile(
                title: Text('Time Table $index'),
              ),
            );
          },
        ),
      ),
    );
  }
}
