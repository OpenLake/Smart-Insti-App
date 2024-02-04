import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/edit_profile.dart';
import '../provider/student_provider.dart';
import '../provider/user_providers.dart';
import '../models/achievement.dart';

class UserProfile extends ConsumerWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.read(studentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.lightBlueAccent,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture and Name
                Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: student.profilePicURI != null
                          ? NetworkImage(student.profilePicURI!)
                          : const AssetImage('assets/openlake.png')
                              as ImageProvider<Object>,
                      radius: 55,
                      child: student.profilePicURI == null
                          ? const Icon(
                              Icons.person,
                              size: 55,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      student.studentNameController.text,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // User Details Card
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildInfoRow(
                          "ID",
                          student.studentRollNoController.text,
                        ),
                        buildInfoRow(
                          "Email",
                          student.studentEmailController.text,
                        ),
                        buildInfoRow(
                          "Branch",
                          student.branch,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'About:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(student.about ?? 'No information'),
                        const SizedBox(height: 16),
                        const Text(
                          'Skills:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Display Skills as a pie chart
                        PieChart(
                          PieChartData(
                            sections: ref.watch(skillsProvider).map((skill) {
                              return PieChartSectionData(
                                value: skill.level.toDouble(),
                                title: skill.name,
                                color: getRandomColor(),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Achievements:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Display Achievements as cards
                        for (var achievement in ref.watch(achievementsProvider))
                          buildAchievementCard(achievement),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(value),
      ],
    );
  }

  Widget buildAchievementCard(Achievement achievement) {
    return Card(
      color: Colors.lightBlue,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${achievement.date}',
              style: const TextStyle(fontSize: 12),
            ),
            // Add description here
          ],
        ),
      ),
    );
  }

  Color getRandomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../screens/edit_profile.dart';
// import '../provider/student_provider.dart';
// import '../provider/user_providers.dart';

// class UserProfile extends ConsumerWidget {
//   const UserProfile({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final studentName =
//         ref.read(studentProvider.notifier).studentNameController.text;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => EditProfileScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           decoration: const BoxDecoration(
//             color: Colors.lightBlueAccent,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Consumer(builder: (context, ref, child) {
//                   return CircleAvatar(
//                     backgroundImage: studentName.profilePicURI != null
//                         ? NetworkImage(studentName.profilePicURI!)
//                         : const AssetImage('assets/openlake.png')
//                             as ImageProvider<Object>,
//                     radius: 55,
//                     child: studentName.profilePicURI == null
//                         ? const Icon(
//                             Icons.person,
//                             size: 55,
//                             color: Colors.grey,
//                           )
//                         : null,
//                   );
//                 }),

//                 // Display About using Riverpod
//                 Text(
//                   'About:',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(ref.read(aboutProvider) ?? 'No information'),

//                 // Display Skills using Riverpod
//                 Text(
//                   'Skills:',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 for (var skill in ref.watch(skillsProvider))
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('${skill.name} - ${skill.level}'),
//                       // Add a slider here if needed
//                     ],
//                   ),

//                 // Display Achievements using Riverpod
//                 Text(
//                   'Achievements:',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 for (var achievement in ref.watch(achievementsProvider))
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         achievement.name,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Date: ${achievement.date}',
//                             style: TextStyle(fontSize: 12),
//                           ),
//                           // Add description here
//                         ],
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../provider/student_provider.dart';
// import '../models/achievement.dart';
// import '../provider/achievements_edit_widget.dart';
// import '../provider/skills_edit_widget.dart';
// import '../provider/about_Edit_widget.dart';

// class UserProfile extends ConsumerWidget {
//   const UserProfile({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final student = ref.read(studentProvider);

//     final TextEditingController aboutController =
//         TextEditingController(text: student.about);
//     final TextEditingController skillsController =
//         TextEditingController(text: student.skills?.toString() ?? "");
//     final TextEditingController achievementsController =
//         TextEditingController(text: student.achievements?.toString() ?? "");

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           decoration: const BoxDecoration(
//             color: Colors.lightBlueAccent,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Consumer(builder: (context, ref, child) {
//                   return CircleAvatar(
//                     backgroundImage: student.profilePicURI != null
//                         ? NetworkImage(student.profilePicURI!)
//                         : const AssetImage('assets/openlake.png')
//                             as ImageProvider<Object>,
//                     radius: 55,
//                     child: student.profilePicURI == null
//                         ? const Icon(
//                             Icons.person,
//                             size: 55,
//                             color: Colors.grey,
//                           )
//                         : null,
//                   );
//                 }),
//                 const SizedBox(height: 16),
//                 Card(
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                   ),
//                   elevation: 5,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           student.studentNameController.text,
//                           style: const TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         buildInfoRow(
//                             "ID", student.studentRollNoController.text),
//                         buildInfoRow(
//                             "Email", student.studentEmailController.text),
//                         buildInfoRow("Branch", student.branch),
//                         // buildInfoRow(
//                         //     "Class of", student.graduationYear ?? "202x"),
//                         const SizedBox(height: 16),
//                         AboutEditorWidget(),
//                         // _buildInfoField("About", aboutController),
//                         // const SizedBox(height: 16),
//                         // _buildInfoField("Roles", values: student.role),
//                         const SizedBox(height: 16),
//                         SkillsEditWidget(skillsController: skillsController),
//                         const SizedBox(height: 16),
//                         AchievementsEditWidget(
//                             achievementsController: achievementsController),
//                         const SizedBox(height: 16),
//                         buildAchievementsColumn(student.achievements),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildInfoRow(String title, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(value),
//       ],
//     );
//   }

//   Widget _buildInfoField(
//     String title, {
//     TextEditingController? controller,
//     List<String>? values,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         if (controller != null) ...[
//           TextField(controller: controller, enabled: false),
//         ] else ...[
//           if (values != null && values.isNotEmpty)
//             for (var value in values) Text('- $value'),
//           if (values == null || values.isEmpty) const Text('- No Information'),
//         ],
//       ],
//     );
//   }

//   Widget buildAchievementsColumn(List<Achievement>? achievements) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Achievements:',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         if (achievements != null)
//           for (var achievement in achievements)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('- ${achievement.name}'),
//                 Text('  ${achievement.description}'),
//               ],
//             ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../provider/student_provider.dart';
// import '../models/achievement.dart';

// class UserProfile extends ConsumerWidget {
//   const UserProfile({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final student = ref.read(studentProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile'),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           color: Colors.lightBlueAccent,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               ConsumerWidget(builder: (_, ref, __) {
//                 return CircleAvatar(
//                   backgroundImage: student.profilePicURI != null
//                       ? NetworkImage(student.profilePicURI!)
//                       : const AssetImage('assets/openlake.png')
//                           as ImageProvider<Object>,
//                   radius: 55,
//                   child: student.profilePicURI == null
//                       ? const Icon(
//                           Icons.person,
//                           size: 55,
//                           color: Colors.grey,
//                         )
//                       : null,
//                 );
//               }),
//               const SizedBox(height: 16),
//               Card(
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//                 elevation: 5,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         student.studentNameController.text,
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       buildInfoRow("ID", student.studentRollNoController.text),
//                       buildInfoRow("Email", student.studentEmailController.text),
//                       buildInfoRow("Branch", student.branch),
//                       buildInfoRow(
//                           "Class of", student.graduationYear ?? "202x"),
//                       const SizedBox(height: 16),
//                       _buildInfoField("About", aboutController),
//                       const SizedBox(height: 16),
//                       _buildInfoField("Roles", values: student.role),
//                       const SizedBox(height: 16),
//                       _buildInfoField("Skills", skillsController),
//                       const SizedBox(height: 16),
//                       buildAchievementsColumn(student.achievements),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildInfoRow(String title, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(value),
//       ],
//     );
//   }

//   Widget _buildInfoField(
//     String title, {
//     TextEditingController? controller,
//     List<String>? values,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         if (controller != null) ...[
//           TextField(controller: controller, enabled: false),
//         ] else ...[
//           if (values != null && values.isNotEmpty)
//             for (var value in values) Text('- $value'),
//           if (values == null || values.isEmpty) const Text('- No Information'),
//         ],
//       ],
//     );
//   }

//   Widget buildAchievementsColumn(List<Achievement>? achievements) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Achievements:',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         if (achievements != null)
//           for (var achievement in achievements)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('- ${achievement.title}'),
//                 Text('  ${achievement.description}'),
//               ],
//             ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import '../models/student.dart';
// import '../provider/student_provider.dart';
// import '../models/achievement.dart';
// // import '../models/skills.dart';

// class UserProfile extends ConsumerWidget {
//   const UserProfile({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final student = ref.watch(studentProvider.notifier);

//     final TextEditingController aboutController =
//         TextEditingController(text: student.about);
//     final TextEditingController skillsController =
//         TextEditingController(text: student.skills?.join(", ") ?? "");

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile'),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           color: Colors.lightBlueAccent,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CircleAvatar(
//                 backgroundImage: student.profilePicURI != null
//                     ? NetworkImage(student.profilePicURI!)
//                     : const AssetImage('assets/openlake.png')
//                         as ImageProvider<Object>,
//                 radius: 55,
//                 child: student.profilePicURI == null
//                     ? const Icon(
//                         Icons.person,
//                         size: 55,
//                         color: Colors.grey,
//                       )
//                     : null,
//               ),
//               const SizedBox(height: 16),
//               Card(
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//                 elevation: 5,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         student.name,
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       buildInfoRow("ID", student.rollNumber),
//                       buildInfoRow("Email", student.email),
//                       buildInfoRow("Branch", student.branch),
//                       buildInfoRow(
//                           "Class of", student.graduationYear ?? "202x"),
//                       const SizedBox(height: 16),
//                       _buildInfoField("About", aboutController),
//                       const SizedBox(height: 16),
//                       _buildInfoField("Roles", values: student.roles),
//                       const SizedBox(height: 16),
//                       _buildInfoField("Skills", skillsController),
//                       const SizedBox(height: 16),
//                       buildAchievementsColumn(student.achievements),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildInfoRow(String title, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(value),
//       ],
//     );
//   }

//   Widget _buildInfoField(
//     String title, {
//     TextEditingController? controller,
//     List<String>? values,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         if (controller != null) ...[
//           TextField(controller: controller, enabled: false),
//         ] else ...[
//           if (values != null && values.isNotEmpty)
//             for (var value in values) Text('- $value'),
//           if (values == null || values.isEmpty) const Text('- No Information'),
//         ],
//       ],
//     );
//   }

//   Widget buildAchievementsColumn(List<Achievement>? achievements) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Achievements:',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         if (achievements != null)
//           for (var achievement in achievements)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('- ${achievement.title}'),
//                 Text('  ${achievement.description}'),
//               ],
//             ),
//       ],
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import '../constants/dummy.dart';

// import '../models/student.dart';
// import '../provider/student_provider.dart';

// bool isEditMode = false;
// TextEditingController achievementsController = TextEditingController();

// class UserProfile extends ConsumerWidget {
//   const UserProfile({super.key});
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final student = ref.read(studentProvider);
//     final TextEditingController aboutController =
//         TextEditingController(text: student.about);
//     final TextEditingController skillsController =
//         TextEditingController(text: student.skills?.join(", ") ?? "");
//     // final TextEditingController achievementController = TextEditingController();
//     // final TextEditingController achievementsController = TextEditingController(
//     //     text: student.achievements?.map((ach) => "${ach.title}: ${ach.description}").join("\n") ?? "");

//     // bool isEditMode = false;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile'),
//         actions: [
//           IconButton(
//             icon: Icon(isEditMode ? Icons.save : Icons.edit),
//             onPressed: () {
//               ref.refresh(studentProvider);

//               // setState(() {
//               //   if (isEditMode) {
//               //     // Save changes to the student object
//               //     // student.about = aboutController.text;
//               //     // student.skills = skillsController.text.split(", ").toList();
//               //     // student.achievements = _parseAchievements();
//               //   }
//               //   isEditMode = !isEditMode;
//               // });
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           color: Colors.lightBlueAccent,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CircleAvatar(
//                 backgroundImage: student.profilePicURI != null
//                     ? NetworkImage(student.profilePicURI!)
//                     : const AssetImage('assets/openlake.png')
//                         as ImageProvider<Object>,
//                 radius: 55,
//                 child: student.profilePicURI == null
//                     ? const Icon(
//                         Icons.person,
//                         size: 55,
//                         color: Colors.grey,
//                       )
//                     : null,
//               ),
//               const SizedBox(height: 16),
//               Card(
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//                 elevation: 5,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         student.name,
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       buildInfoRow("ID", student.rollNumber),
//                       buildInfoRow("Email", student.studentMail),
//                       buildInfoRow("Branch", student.branch),
//                       buildInfoRow(
//                           "Class of", student.graduationYear ?? "202x"),
//                       const SizedBox(height: 16),
//                       _buildEditableField(
//                         "About",
//                         aboutController,
//                         isEditMode,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildEditableField(
//                         "Roles",
//                         null,
//                         isEditMode,
//                         values: student.roles,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildEditableField(
//                         "Skills",
//                         skillsController,
//                         isEditMode,
//                       ),
//                       const SizedBox(height: 16),
//                       buildAchievementsColumn(student.achievements),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildInfoRow(String title, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(value),
//       ],
//     );
//   }

//   Widget _buildEditableField(
//     String title,
//     TextEditingController? controller,
//     bool isEditable, {
//     List<String>? values,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         if (isEditable) ...[
//           if (controller != null) TextField(controller: controller),
//           if (values != null) ...[
//             for (var value in values) Text('- $value'),
//           ]
//         ] else ...[
//           if (values != null && values.isNotEmpty)
//             for (var value in values) Text('- $value'),
//           if (values == null || values.isEmpty) const Text('- No Information'),
//         ],
//       ],
//     );
//   }

//   Widget buildAchievementsColumn(List<Achievement>? achievements) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Achievements:',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         if (isEditMode) ...[
//           if (achievementsController != null)
//             TextField(controller: achievementsController),
//         ] else ...[
//           if (achievements != null)
//             for (var achievement in achievements)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('- ${achievement.title}'),
//                   Text('  ${achievement.description}'),
//                 ],
//               ),
//         ],
//       ],
//     );
//   }

  // List<Achievement>? _parseAchievements() {
  //   final lines = achievementsController.text.split("\n");
  //   return lines
  //       .map((line) {
  //         final parts = line.split(": ");
  //         return Achievement(title: parts[0], description: parts[1]);
  //       })
  //       .where((ach) => ach.title.isNotEmpty && ach.description.isNotEmpty)
  //       .toList();
  // }
// }
// import 'package:flutter/material.dart';
// import '../constants/dummy.dart';
// import '../models/student.dart';

// class UserProfile extends StatefulWidget {
//   @override
//   _UserProfileState createState() => _UserProfileState();
// }

// class _UserProfileState extends State<UserProfile> {
//   late TextEditingController aboutController;
//   late TextEditingController skillsController;
//   late TextEditingController achievementsController;

//   bool isEditMode = false;

//   @override
//   void initState() {
//     super.initState();
//     aboutController =
//         TextEditingController(text: DummyStudents.students[0].about);
//     skillsController = TextEditingController(
//         text: DummyStudents.students[0].skills?.join(", ") ?? "");
//     achievementsController = TextEditingController(
//         text: DummyStudents.students[0].achievements
//                 ?.map((ach) => "${ach.title}: ${ach.description}")
//                 .join("\n") ??
//             "");
//   }

//   @override
//   void dispose() {
//     aboutController.dispose();
//     skillsController.dispose();
//     achievementsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile'),
//         actions: [
//           IconButton(
//             icon: Icon(isEditMode ? Icons.save : Icons.edit),
//             onPressed: () {
//               setState(() {
//                 if (isEditMode) {
//                   // Save changes to the student object
//                   // DummyStudents.students[0].about = aboutController.text;
//                   // DummyStudents.students[0].skills =
//                   //     skillsController.text.split(", ").toList();
//                   // DummyStudents.students[0].achievements = _parseAchievements();
//                 }
//                 isEditMode = !isEditMode;
//               });
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           color: Colors.lightBlueAccent,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CircleAvatar(
//                 backgroundImage: DummyStudents.students[0].profilePicURI != null
//                     ? NetworkImage(DummyStudents.students[0].profilePicURI!)
//                     : AssetImage('assets/openlake.png')
//                         as ImageProvider<Object>,
//                 radius: 55,
//                 child: DummyStudents.students[0].profilePicURI == null
//                     ? const Icon(
//                         Icons.person,
//                         size: 55,
//                         color: Colors.grey,
//                       )
//                     : null,
//               ),
//               const SizedBox(height: 16),
//               Card(
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//                 elevation: 5,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         DummyStudents.students[0].name,
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       buildInfoRow("ID", DummyStudents.students[0].rollNumber),
//                       buildInfoRow(
//                           "Email", DummyStudents.students[0].studentMail),
//                       buildInfoRow("Branch", DummyStudents.students[0].branch),
//                       buildInfoRow(
//                         "Class of",
//                         DummyStudents.students[0].graduationYear ?? "202x",
//                       ),
//                       const SizedBox(height: 16),
//                       _buildEditableField(
//                         "About",
//                         aboutController,
//                         isEditMode,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildEditableField(
//                         "Roles",
//                         null,
//                         isEditMode,
//                         values: DummyStudents.students[0].roles,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildEditableField(
//                         "Skills",
//                         skillsController,
//                         isEditMode,
//                       ),
//                       const SizedBox(height: 16),
//                       buildAchievementsColumn(
//                           DummyStudents.students[0].achievements),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildInfoRow(String title, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(value),
//       ],
//     );
//   }

//   Widget _buildEditableField(
//     String title,
//     TextEditingController? controller,
//     bool isEditable, {
//     List<String>? values,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         if (isEditable) ...[
//           if (controller != null) TextField(controller: controller),
//           if (values != null) ...[
//             for (var value in values) Text('- $value'),
//           ]
//         ] else ...[
//           if (values != null && values.isNotEmpty)
//             for (var value in values) Text('- $value'),
//           if (values == null || values.isEmpty) const Text('- No Information'),
//         ],
//       ],
//     );
//   }

//   Widget buildAchievementsColumn(List<Achievement>? achievements) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Achievements:',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         if (isEditMode) ...[
//           if (achievementsController != null)
//             TextField(controller: achievementsController),
//         ] else ...[
//           if (achievements != null)
//             for (var achievement in achievements)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('- ${achievement.title}'),
//                   Text('  ${achievement.description}'),
//                 ],
//               ),
//         ],
//       ],
//     );
//   }

//   List<Achievement>? _parseAchievements() {
//     final lines = achievementsController.text.split("\n");
//     return lines
//         .map((line) {
//           final parts = line.split(": ");
//           return Achievement(title: parts[0], description: parts[1]);
//         })
//         .where((ach) => ach.title.isNotEmpty && ach.description.isNotEmpty)
//         .toList();
//   }
// }