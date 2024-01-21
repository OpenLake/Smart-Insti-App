import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:slide_switcher/slide_switcher.dart';

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
        body: Column(
          children: [
            Consumer<MenuProvider>(
              builder: (_, menuProvider, ___) {
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10,top: 100),
                      child: SlideSwitcher(
                        onSelect: (index) {},
                        containerHeight: 550,
                        containerWight: 70,
                        direction: Axis.vertical,

                        slidersColors: [Colors.greenAccent],
                        containerColor: Colors.grey.shade300,
                        children: const [
                          Text('Sun'),
                          Text('Mon'),
                          Text('Tue'),
                          Text('Wed'),
                          Text('Thu'),
                          Text('Fri'),
                          Text('Sat'),
                        ],
                      ),
                    ),
                    Container(
                      child: SizedBox(
                        height: 600,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            child: SlideSwitcher(
                              onSelect: (index) {},
                              containerHeight: 60,
                              containerWight: 300,
                              slidersColors: [Colors.greenAccent],
                              containerColor: Colors.grey.shade300,
                              children: [
                                Container(width: 70,child: Text('Breakfast')),
                                Text('Lunch'),
                                Text('Snacks'),
                                Text('Dinner'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ), // many more parameters available
          ],
        ),
      ),
    );
  }
}
