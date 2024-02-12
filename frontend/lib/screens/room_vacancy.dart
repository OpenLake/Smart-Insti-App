import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/components/borderless_button.dart';
import 'package:smart_insti_app/components/menu_tile.dart';
import 'package:smart_insti_app/constants/constants.dart';
import 'package:smart_insti_app/provider/room_provider.dart';
import '../models/room.dart';
import '../provider/auth_provider.dart';

class RoomVacancy extends ConsumerWidget {
  const RoomVacancy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider).tokenCheckProgress != LoadingState.progress) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(context);
      }
    });
    if (ref.read(roomProvider).loadingState == LoadingState.progress) ref.read(roomProvider.notifier).loadRooms();
    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Room Vacancy'),
        ),
        body: ref.watch(roomProvider).loadingState == LoadingState.success
            ? ref.read(roomProvider).roomList.isNotEmpty
                ? GridView.count(
                    crossAxisCount: 2,
                    children: [
                      for (Room room in ref.read(roomProvider).roomList)
                        MenuTile(
                          title: room.name,
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("${room.name} : ${room.vacant ? 'Vacant' : 'Occupied'}",
                                        style: const TextStyle(fontSize: 20)),
                                    const SizedBox(height: 20),
                                    room.vacant
                                        ? Row(
                                            children: [
                                              BorderlessButton(
                                                onPressed: () => context.pop(),
                                                label: const Text('Cancel'),
                                                backgroundColor: Colors.red.shade100,
                                                splashColor: Colors.redAccent,
                                              ),
                                              const Spacer(),
                                              BorderlessButton(
                                                onPressed: () {
                                                  ref.read(roomProvider.notifier).reserveRoom(room);
                                                  context.pop();
                                                },
                                                label: const Text('Reserve'),
                                                backgroundColor: Colors.blue.shade100,
                                                splashColor: Colors.blueAccent,
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          body: [
                            const SizedBox(height: 5),
                            Text(
                              room.vacant ? 'Vacant' : 'Occupied',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 10),
                            room.vacant ? Container() : const Text("by : Aadarsh"),
                          ],
                          icon: Icons.class_,
                          primaryColor: room.vacant ? Colors.greenAccent.shade100 : Colors.redAccent.shade100,
                          secondaryColor: room.vacant ? Colors.greenAccent.shade200 : Colors.redAccent.shade200,
                        ),
                    ],
                  )
                : const Center(child: Text('No rooms found'))
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
