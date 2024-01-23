import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/components/borderless_button.dart';
import 'package:smart_insti_app/components/collapsing_app_bar.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/provider/room_provider.dart';

import '../../components/text_divider.dart';

class ManageRooms extends StatelessWidget {
  const ManageRooms({super.key});

  @override
  Widget build(BuildContext context) {
    RoomProvider roomProvider = Provider.of<RoomProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      roomProvider.searchRooms();
    });
    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 15, right: 10),
          width: 75,
          height: 75,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => Dialog(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Add Room',
                          style: TextStyle(fontSize: 30),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 300,
                          child: MaterialTextFormField(
                            controller: roomProvider.roomNameController,
                            hintText: 'Enter room name',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BorderlessButton(
                              onPressed: () => context.pop(),
                              splashColor: Colors.redAccent,
                              backgroundColor: Colors.redAccent.shade100.withOpacity(0.2),
                              label: const Text('Cancel'),
                            ),
                            BorderlessButton(
                              onPressed: () {
                                Logger().i("Adding room");
                                context.pop();
                                roomProvider.addRoom();
                                roomProvider.searchRooms();
                              },
                              splashColor: Colors.blueAccent,
                              backgroundColor: Colors.blueAccent.shade100.withOpacity(0.2),
                              label: const Text('Add'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              child: const Icon(Icons.add),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CollapsingAppBar(
              title: const Text(
                'Manage Rooms',
                style: TextStyle(color: Colors.black),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
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
                          onPressed: () => roomProvider.pickSpreadsheet(),
                          style: ButtonStyle(minimumSize: MaterialStateProperty.all(const Size(200, 60))),
                          child: const Text("Upload Spreadsheet"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const TextDivider(text: "OR"),
                  const SizedBox(height: 30),
                ],
              ),
              height: 370,
              bottom: Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(
                      width: 390,
                      child: SearchBar(
                        controller: roomProvider.searchRoomController,
                        hintText: 'Enter room name',
                        onChanged: (value) {
                          roomProvider.searchRooms();
                        },
                        onSubmitted: (value) {
                          roomProvider.searchRooms();
                        },
                        padding: MaterialStateProperty.all(const EdgeInsets.only(left: 15)),
                        shadowColor: MaterialStateProperty.all(Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
          body: Container(
            color: Colors.white,
            child: Consumer<RoomProvider>(
              builder: (_, __, ___) {
                return GridView.count(
                  padding: const EdgeInsets.all(10),
                  crossAxisCount: 2,
                  children: roomProvider.buildRoomTiles(context),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
