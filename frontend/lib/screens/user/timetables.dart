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
                    content: SizedBox(
                      width: 400,
                      height: 305,
                      child: Form(
                        key: _formKey,
                  child: Column(
                    children: [
                            const Text(
                        'Add Time Table',
                        style: TextStyle(fontSize: 28),
                      ),
                            const SizedBox(height: 20),
                            MaterialTextFormField(
                              hintText: "Timetable name",
                              controller: ref.read(timetableProvider).timetableNameController,
                              validator: (value) => Validators.nameValidator(value),
                            ),
                            const SizedBox(height: 20),
                      Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                                  width: 70,
                                  child: MaterialTextFormField(
                                    controller: ref.read(timetableProvider).rowsController,
                                    textAlign: TextAlign.center,
                                    enabled: false,
                                    hintText: '',
                                  ),
                                ),
                                const SizedBox(width: 15),
                                const Text('X', style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 15),
                                Tooltip(
                                  key: _toolTipKey,
                                  verticalOffset: 40,
                                  showDuration: const Duration(seconds: 1),
                                  message: "Please enter number of columns",
                                  triggerMode: TooltipTriggerMode.manual,
                                  child: SizedBox(
                                    width: 70,
                                    child: MaterialTextFormField(
                                      hintText: "",
                                      textAlign: TextAlign.center,
                                      controller: ref.read(timetableProvider).columnsController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(1),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Include Saturday?', style: TextStyle(fontSize: 15)),
                                const SizedBox(width: 20),
                                Consumer(
                                  builder: (_, ref, __) => AnimatedToggleSwitch.dual(
                                    height: 45,
                                    spacing: 15,
                                    onTap: (value) {
                                      ref.read(timetableProvider.notifier).toggleIncludeSaturday();
                                    },
                                    current: ref.watch(timetableProvider).includeSaturday,
                                    first: true,
                                    second: false,
                                    styleBuilder: (value) => value
                                        ? ToggleStyle(
                                            indicatorColor: Colors.teal,
                                            backgroundColor: Colors.tealAccent.shade100,
                                            borderColor: Colors.transparent,
                                          )
                                        : ToggleStyle(
                                            indicatorColor: Colors.redAccent,
                                            backgroundColor: Colors.redAccent.shade100,
                                            borderColor: Colors.transparent,
                                          ),
                                    iconBuilder: (value) => value
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          )
                                        : const Icon(
                                            Icons.not_interested_rounded,
                                            color: Colors.white,
                                          ),
                                  ),
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
