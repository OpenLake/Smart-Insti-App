import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/dummy_entries.dart';
import '../models/skills.dart';
import '../models/achievement.dart';

final aboutProvider = StateProvider<String?>((ref) => null);
final skillsProvider = StateProvider<List<Skill>>((ref) => DummySkills.skills);
final achievementsProvider =
    StateProvider<List<Achievement>>((ref) => Dummyachievements.achievements);
