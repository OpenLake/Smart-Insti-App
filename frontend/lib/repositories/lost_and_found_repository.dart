import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_insti_app/constants/dummy_entries.dart';
import 'package:smart_insti_app/models/lost_and_found_item.dart';

final lostAndFoundRepositoryProvider = Provider<LostAndFoundRepository>((_) => LostAndFoundRepository());

class LostAndFoundRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000',
    ),
  );

  Future<List<LostAndFoundItem>> lostAndFoundItems() async {
    try {
      final response = await _client.get('/lost-and-found');
      return response.data.map((e) => LostAndFoundItem.fromJson(e)).toList();
    } catch (e) {
      return DummyLostAndFound.lostAndFoundItems;
    }
  }
}
