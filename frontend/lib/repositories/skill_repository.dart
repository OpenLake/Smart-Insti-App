import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/dummy_entries.dart';
import '../models/skills.dart';

final skillRepositoryProvider =
    Provider<SkillRepository>((_) => SkillRepository());

class SkillRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000',
    ),
  );

  Future<List<dynamic>> Skills() async {
    try {
      final response = await _client.get('/skills');
      return response.data.map((e) => Skill.fromJson(e)).toList();
    } catch (e) {
      return DummySkills.skills;
    }
  }
}
