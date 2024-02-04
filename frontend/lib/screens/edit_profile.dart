import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../provider/user_providers.dart';
// import '../models/skills.dart';
// import '../models/achievement.dart';
import '../provider/skills_edit_widget.dart';
import '../provider/achievements_edit_widget.dart';
import '../provider/about_Edit_widget.dart';
import 'dart:convert';

class EditProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutController = ref.watch(aboutControllerProvider);
    final skills = ref.watch(skillsProvider);
    final achievements = ref.watch(achievementsProvider);

    String skillsJson = jsonEncode(skills);
    String achievementsJson = jsonEncode(achievements);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit About',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              AboutEditWidget(),
              // UI for editing skills
              SkillsEditWidget(
                skillsController: TextEditingController(text: skillsJson),
              ),
              // UI for editing achievements
              AchievementsEditWidget(
                achievementsController:
                    TextEditingController(text: achievementsJson),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../provider/user_providers.dart';
// import '../models/skills.dart';
// import '../models/achievement.dart';
// import '../provider/skills_edit_widget.dart';
// import '../provider/achievements_edit_widget.dart';
// import 'dart:convert';

// class EditProfileScreen extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     TextEditingController aboutController =
//         TextEditingController(text: ref.watch(aboutProvider) ?? "");

//     List<Skill> skills = ref.watch(skillsProvider);
//     List<Achievement> achievements = ref.watch(achievementsProvider);

//     String skillsJson = jsonEncode(skills);
//     String achievementsJson = jsonEncode(achievements);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Edit About',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//               TextField(
//                 controller: aboutController,
//                 onChanged: (newAbout) {
//                   // ref.read(aboutProvider).state = newAbout;
//                 },
//                 decoration: const InputDecoration(
//                   hintText: 'Write something about yourself...',
//                 ),
//                 maxLines: 5,
//               ),

//               // UI for editing skills
//               SkillsEditWidget(
//                 skillsController: TextEditingController(text: skillsJson),
//               ),

//               // UI for editing achievements
//               AchievementsEditWidget(
//                 achievementsController:
//                     TextEditingController(text: achievementsJson),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
