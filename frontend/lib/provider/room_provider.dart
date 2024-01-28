import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/components/borderless_button.dart';
import 'package:smart_insti_app/constants/dummy_entries.dart';
import 'package:smart_insti_app/components/menu_tile.dart';
import 'package:smart_insti_app/models/room.dart';
import 'dart:io';

final roomProvider = StateNotifierProvider<RoomProvider, RoomState>((ref) => RoomProvider());

class RoomState {
  final List<Room> roomList;
  final List<MenuTile> roomTiles;
  final TextEditingController searchRoomController;
  final TextEditingController roomNameController;

  RoomState({
    required this.roomList,
    required this.roomTiles,
    required this.searchRoomController,
    required this.roomNameController,
  });

  RoomState copyWith({
    List<Room>? roomList,
    List<MenuTile>? roomTiles,
    TextEditingController? searchRoomController,
    TextEditingController? roomNameController,
  }) {
    return RoomState(
      roomList: roomList ?? this.roomList,
      roomTiles: roomTiles ?? this.roomTiles,
      searchRoomController: searchRoomController ?? this.searchRoomController,
      roomNameController: roomNameController ?? this.roomNameController,
    );
  }
}

class RoomProvider extends StateNotifier<RoomState> {
  RoomProvider()
      : super(RoomState(
          roomList: DummyRooms.rooms,
          roomTiles: [],
          searchRoomController: TextEditingController(),
          roomNameController: TextEditingController(),
        ));

  final Logger _logger = Logger();

  void pickSpreadsheet() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      bool isSpreadsheet = result.files.single.path!.endsWith(".xlsx") ||
          result.files.single.path!.endsWith(".xls") ||
          result.files.single.path!.endsWith(".csv");
      if (isSpreadsheet) {
        File file = File(result.files.single.path!);

        // TODO : Add code to send the spreadsheet to the backend

        _logger.i("Picked file ${file.path}");
      } else {
        _logger.e("Picked file is not a spreadsheet");
      }
    } else {
      _logger.e("No file picked");
    }
  }

  void addRoom() {
    final newState = state.copyWith(
      roomList: [
        Room(name: state.roomNameController.text),
        ...state.roomList,
      ],
      roomNameController: TextEditingController(),
    );
    state = newState;
    _logger.i("Added room: ${state.roomNameController.text}");
  }

  void buildRoomTiles(BuildContext context) {
    final roomTiles = <MenuTile>[];
    for (Room room in state.roomList) {
      roomTiles.add(
        MenuTile(
          title: room.name,
          onTap: () => showDialog(
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
                    Text(room.name),
                    const SizedBox(height: 20),

                    /// TODO : Add code to edit room

                    const Text("Room editing will be added in future"),
                    const SizedBox(height: 20),
                    BorderlessButton(
                      onPressed: () {
                        removeRoom(room);
                        buildRoomTiles(context);
                        context.pop();
                      },
                      label: const Text("Remove"),
                      backgroundColor: Colors.red.shade100,
                      splashColor: Colors.redAccent,
                    )
                  ],
                ),
                      ),
                    ),
              ),
          icon: Icons.add,
          primaryColor: Colors.grey.shade200,
          secondaryColor: Colors.grey.shade300,
        ),
      );
    }
    String query = state.searchRoomController.text;
    state = state.copyWith(
      roomTiles: roomTiles.where((element) => element.title.toLowerCase().contains(query.toLowerCase())).toList(),
    );
    _logger.i("Built room tiles : ${roomTiles.length}");
  }

  void removeRoom(Room room) {
    final newState = state.copyWith(
      roomList: [
        ...state.roomList.where((element) => element.name != room.name),
      ],
    );
    state = newState;
    _logger.i("Removed room: ${room.name}");
  }
}
