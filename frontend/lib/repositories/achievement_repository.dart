import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/dummy_entries.dart';
import '../models/achievement.dart';

final achievementRepositoryProvider =
    Provider<AchievementRepository>((_) => AchievementRepository());

class AchievementRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000',
    ),
  );

  Future<List<dynamic>> Achievements() async {
    try {
      final response = await _client.get('/achievements');
      return response.data.map((e) => Achievement.fromJson(e)).toList();
    } catch (e) {
      return DummyAchievements.achievements;
    }
  }
}
