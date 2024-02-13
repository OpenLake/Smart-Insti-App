import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/dummy_entries.dart';
import 'package:smart_insti_app/models/lost_and_found_item.dart';

final lostAndFoundRepositoryProvider = Provider<LostAndFoundRepository>((_) => LostAndFoundRepository());

class LostAndFoundRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BACKEND_DOMAIN']!,
      headers: {
        "Content-Type": "multipart/form-data",
      },
    ),
  );

  Future<List<LostAndFoundItem>> lostAndFoundItems() async {
    try {
      final response = await _client.get('/lost-and-found');
      List<LostAndFoundItem> items = [];
      for (var item in response.data) {
        items.add(LostAndFoundItem.fromJson(item));
      }
      return items;
    } catch (e) {
      Logger().e(e);
      return DummyLostAndFound.lostAndFoundItems;
    }
  }

  Future<void> addLostAndFoundItem(LostAndFoundItem item) async {
    try {
      String? fileName = item.imagePath?.split('/').last;
      FormData formData = FormData.fromMap({
        "name": item.name,
        "lastSeenLocation": item.lastSeenLocation,
        "description": item.description,
        "contactNumber": item.contactNumber,
        "isLost": item.isLost,
        "image": item.imagePath != null
            ? await MultipartFile.fromFile(
                item.imagePath!,
                filename: fileName,
              )
            : null,
      });
      final response = await _client.post('/lost-and-found', data: formData);
      Logger().w(response.data);
    } catch (e) {
      Logger().e(e);
    }
  }
}
