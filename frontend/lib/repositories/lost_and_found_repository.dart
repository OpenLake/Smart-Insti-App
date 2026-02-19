import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/dummy_entries.dart';
import 'package:smart_insti_app/models/lost_and_found_item.dart';
import 'package:http_parser/http_parser.dart';
import 'package:smart_insti_app/constants/constants.dart';

final lostAndFoundRepositoryProvider = Provider<LostAndFoundRepository>((_) => LostAndFoundRepository());

class LostAndFoundRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      headers: {
        "Content-Type": "multipart/form-data",
      },
    ),
  );

  final Logger _logger = Logger();

  Future<List<LostAndFoundItem>> lostAndFoundItems() async {
    try {
      final response = await _client.get('/lost-and-found');
      final itemsJson = response.data['data'] as List; // <-- extract "data"
      List<LostAndFoundItem> items = itemsJson
          .map((item) => LostAndFoundItem.fromJson(item))
          .toList();
      return items;
    } catch (e) {
      Logger().e(e);
      return DummyLostAndFound.lostAndFoundItems;
    }
  }

  Future<bool> deleteLostAndFoundItem(String id) async {
    try {
      final response = await _client.delete('/lost-and-found-item/$id');
      Logger().i(response.data);
      return true;
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }

  Future<bool> addLostAndFoundItem(LostAndFoundItem item) async {
    try {
      String? fileName = item.imagePath?.split('/').last;

      // Use dynamic to allow MultipartFile
      final Map<String, dynamic> formMap = {
        "name": item.name ?? "",
        "lastSeenLocation": item.lastSeenLocation ?? "",
        "description": item.description ?? "",
        "contactNumber": item.contactNumber ?? "",
        "isLost": item.isLost.toString(),   // "true" or "false"
      };

      // Only include listerId if it's non-empty
      if (item.listerId != null && item.listerId!.isNotEmpty) {
        formMap["listerId"] = item.listerId;
      }

      // Only include image if it's present
      if (item.imagePath != null) {
        formMap["image"] = await MultipartFile.fromFile(
          item.imagePath!,
          filename: fileName,
          contentType: MediaType("image", "jpeg"),
        );
      }

      FormData formData = FormData.fromMap(formMap);

      final response = await _client.post('/lost-and-found', data: formData);
      Logger().i(response.data);
      return true;
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }

}