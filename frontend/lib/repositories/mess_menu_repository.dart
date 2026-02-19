import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/models/mess_menu.dart';
import 'package:smart_insti_app/constants/constants.dart';

final messMenuRepositoryProvider = Provider<MessMenuRepository>((ref) => MessMenuRepository());

class MessMenuRepository{

  final _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final Logger _logger = Logger();

 Future<List<MessMenu>> getMessMenu() async {
    try {
      final response = await _client.get('/mess-menus');
      // Backend returns { status: true, data: [...] }
      final data = response.data;
      List<dynamic> list = (data is Map && data.containsKey('data')) ? data['data'] : data;
      
      List<MessMenu> messMenus = list.map((e) => MessMenu.fromJson(e)).toList();
      return messMenus;
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  Future<bool> addMessMenu(MessMenu messMenu) async {
    try {
      final response = await _client.post('/mess-menus', data: messMenu.toJson());
      _logger.i(response.data);
      return true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<bool> updateMessMenu(String menuId, MessMenu messMenu) async {
    try {
      final response = await _client.put('/mess-menu/$menuId', data: messMenu.toJson());
      _logger.i(response.data);
      return true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<bool> deleteMessMenu(String id) async {
    try {
      final response = await _client.delete('/mess-menu/$id');
      _logger.i(response.data);
      return true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }
}