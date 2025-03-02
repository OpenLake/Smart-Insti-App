import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/components/menu_tile.dart';
import 'package:smart_insti_app/models/room.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import 'dart:io';
import '../constants/constants.dart';
import '../models/admin.dart';
import '../models/faculty.dart';
import '../models/student.dart';
import '../repositories/room_repository.dart';

final roomProvider = StateNotifierProvider<RoomProvider, RoomState>((ref) => RoomProvider(ref));

class RoomState {
  final List<Room> roomList;
  final List<MenuTile> roomTiles;
  final TextEditingController searchRoomController;
  final TextEditingController roomNameController;
  final LoadingState loadingState;

  RoomState(
      {required this.roomList,
      required this.roomTiles,
      required this.searchRoomController,
      required this.roomNameController,
      required this.loadingState});

  RoomState copyWith({
    List<Room>? roomList,
    List<MenuTile>? roomTiles,
    TextEditingController? searchRoomController,
    TextEditingController? roomNameController,
    LoadingState? loadingState,
  }) {
    return RoomState(
      roomList: roomList ?? this.roomList,
      roomTiles: roomTiles ?? this.roomTiles,
      searchRoomController: searchRoomController ?? this.searchRoomController,
      roomNameController: roomNameController ?? this.roomNameController,
      loadingState: loadingState ?? this.loadingState,
    );
  }
}

class RoomProvider extends StateNotifier<RoomState> {
  RoomProvider(Ref ref)
      : _api = ref.read(roomRepositoryProvider),
        super(
          RoomState(
            roomList: [],
            roomTiles: [],
            searchRoomController: TextEditingController(),
            roomNameController: TextEditingController(),
            loadingState: LoadingState.progress,
          ),
        ) {
    loadRooms();
  }

  final RoomRepository _api;
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

  void rebuildPage() => state = state.copyWith();

  Future<void> addRoom() async {
    if (await _api.addRoom(Room(name: state.roomNameController.text, vacant: true))) {
      loadRooms();
      state.roomNameController.clear();
    }
  }

  Future<void> loadRooms() async {
    final rooms = await _api.getRooms();
    final newState = state.copyWith(roomList: rooms, loadingState: LoadingState.success);
    state = newState;
  }

  Future<void> reserveRoom(AuthState authState, Room room) async {
    String userId;
    String userName;

    if (authState.currentUserRole == 'student') {
      userId = (authState.currentUser as Student).id!;
      userName = (authState.currentUser as Student).name;
    } else if (authState.currentUserRole == 'faculty') {
      userId = (authState.currentUser as Faculty).id!;
      userName = (authState.currentUser as Faculty).name;
    } else if (authState.currentUserRole == 'admin') {
      userId = (authState.currentUser as Admin).id;
      userName = (authState.currentUser as Admin).name;
    } else {
      return;
    }
    state = state.copyWith(loadingState: LoadingState.progress);
    if (await _api.reserveRoom(room.id!, userId, userName)) {
      loadRooms();
    } else {
      state = state.copyWith(loadingState: LoadingState.error);
    }
  }

  Future<void> vacateRoom(Room room) async {
    state = state.copyWith(loadingState: LoadingState.progress);

    if (await _api.vacateRoom(room.id!)) {
      loadRooms();
    } else {
      state = state.copyWith(loadingState: LoadingState.error);
    }
  }

  Future<void> removeRoom(Room room) async {
    if (await _api.removeRoom(room.id!)) {
      loadRooms();
    }
  }
}
