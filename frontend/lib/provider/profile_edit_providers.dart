import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/achievement.dart';
import '../models/skills.dart';

// --- About Provider ---
final aboutProvider = Provider<String?>((ref) {
  return ref.watch(aboutControllerProvider);
});

final aboutControllerProvider =
    StateNotifierProvider<AboutController, String?>((ref) {
  return AboutController();
});

class AboutController extends StateNotifier<String?> {
  AboutController() : super("");

  void updateAbout(String about) {
    state = about;
  }
}

// --- Achievements Provider ---
final achievementsProvider = Provider<List<Achievement>>((ref) {
  return ref.watch(achievementsControllerProvider);
});

final achievementsControllerProvider =
    StateNotifierProvider<AchievementsController, List<Achievement>>((ref) {
  return AchievementsController();
});

class AchievementsController extends StateNotifier<List<Achievement>> {
  AchievementsController() : super([]);

  void addAchievement(Achievement achievement) {
    state = [...state, achievement];
  }

  void updateAchievement(int index, Achievement achievement) {
    state = [...state];
    state[index] = achievement;
  }

  void removeAchievement(int index) {
    state = [...state]..removeAt(index);
  }
}

// --- Skills Provider ---
final skillsProvider = Provider<List<Skill>>((ref) {
  return ref.watch(skillsControllerProvider);
});

final skillsControllerProvider =
    StateNotifierProvider<SkillsController, List<Skill>>((ref) {
  return SkillsController();
});

class SkillsController extends StateNotifier<List<Skill>> {
  SkillsController() : super([]);

  void addSkill(Skill skill) {
    state = [...state, skill];
  }

  void updateSkill(int index, Skill skill) {
    state = [...state];
    state[index] = skill;
  }

  void removeSkill(int index) {
    state = [...state]..removeAt(index);
  }
}
