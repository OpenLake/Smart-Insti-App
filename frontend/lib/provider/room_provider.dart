import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/components/borderless_button.dart';
import 'package:smart_insti_app/constants/dummy_entries.dart';
import '../components/menu_tile.dart';
import '../models/room.dart';
import 'dart:io';

class RoomProvider extends ChangeNotifier {
  final TextEditingController _searchRoomController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();

  TextEditingController get searchRoomController => _searchRoomController;

  TextEditingController get roomNameController => _roomNameController;

  List<Room> roomList = DummyRooms.rooms;
  List<Room> filteredRoomList = [];

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
    Room room = Room(
      name: _roomNameController.text,
    );
    _logger.i("Added room: ${room.name}");
    roomList.add(room);
    _roomNameController.clear();
    notifyListeners();
  }

  List<MenuTile> buildRoomTiles(BuildContext context) {
    List<MenuTile> roomTiles = [];
    for (Room room in filteredRoomList) {
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
                        Navigator.pop(context);
                        removeRoom(room);
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
    _logger.i("Built room tiles : ${roomTiles.length}");
    return roomTiles;
  }

  void searchRooms() {
    String query = _searchRoomController.text;
    _logger.i("Searching for room: $query");
    filteredRoomList = roomList.where((room) => room.name.toLowerCase().contains(query.toLowerCase())).toList();
    notifyListeners();
  }

  void removeRoom(Room room) {
    roomList.remove(room);
    _logger.i("Removed room: ${room.name}");
    String query = _searchRoomController.text;
    filteredRoomList = roomList.where((room) => room.name.toLowerCase().contains(query.toLowerCase())).toList();
    notifyListeners();
  }
}
