import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_insti_app/constants/dummy_entries.dart';
import '../models/room.dart';

final roomRepositoryProvider = Provider<RoomRepository>((_) => RoomRepository());

class RoomRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000',
    ),
  );

  Future<List<Room>> getRooms() async {
    try {
      final response = await _client.get('/rooms');
      return response.data.map((e) => Room.fromJson(e)).toList();
    } catch (e) {
      return DummyRooms.rooms;
    }
  }

  Future<void> reserveRoom(String roomId, String occupantId) async {
    try {
      final response = await _client.put('/room/$roomId', data: {'occupantId': occupantId});
      Logger().i(response.data);
    } catch (e) {
      Logger().e(e);
    }
  }

  void addRoom(Room room) async {
    try {
      final response = await _client.post('/rooms', data: room.toJson());
      Logger().i(response.data);
    } catch (e) {
      Logger().e(e);
    }
  }
}
