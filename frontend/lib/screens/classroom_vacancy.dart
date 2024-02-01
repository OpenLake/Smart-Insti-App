import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/components/menu_tile.dart';
import 'package:smart_insti_app/provider/room_provider.dart';

import '../models/room.dart';

class ClassroomVacancy extends ConsumerWidget {
  const ClassroomVacancy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Classroom Vacancy'),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: [
            for (Room room in ref.read(roomProvider).roomList)
              MenuTile(
                title: room.name,
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(room.name),
                    content: Column(
                      children: [
                        Text(room.vacant ? 'Vacant' : 'Occupied'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
                body: [
                  const SizedBox(height: 5),
                  Text(
                    room.vacant ? 'Vacant' : 'Occupied',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 10),
                  room.vacant ? Container() : const Text("{Occupant Name}"),
                  // const SizedBox(height: 5),
                  // Text(
                  //   room.vacant ? '0' : '1',
                  //   textAlign: TextAlign.center,
                  //   style: const TextStyle(fontSize: 14),
                  // ),
                ],
                icon: Icons.class_,
                primaryColor: room.vacant ? Colors.greenAccent.shade100 : Colors.redAccent.shade100,
                secondaryColor: room.vacant ? Colors.greenAccent.shade200 : Colors.redAccent.shade200,
              ),
          ],
        ),
      ),
    );
  }
}
