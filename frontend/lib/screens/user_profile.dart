import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../constants/dummy.dart';

import '../models/student2.dart';
import '../routes/student_provide.dart';

bool isEditMode = false;
TextEditingController achievementsController = TextEditingController();

class UserProfile extends ConsumerWidget {
  const UserProfile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.read(studentProvider);
    final TextEditingController aboutController =
        TextEditingController(text: student.about);
    final TextEditingController skillsController =
        TextEditingController(text: student.skills?.join(", ") ?? "");
    // final TextEditingController achievementController = TextEditingController();
    // final TextEditingController achievementsController = TextEditingController(
    //     text: student.achievements?.map((ach) => "${ach.title}: ${ach.description}").join("\n") ?? "");

    // bool isEditMode = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.save : Icons.edit),
            onPressed: () {
              ref.refresh(studentProvider);

              // setState(() {
              //   if (isEditMode) {
              //     // Save changes to the student object
              //     // student.about = aboutController.text;
              //     // student.skills = skillsController.text.split(", ").toList();
              //     // student.achievements = _parseAchievements();
              //   }
              //   isEditMode = !isEditMode;
              // });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.lightBlueAccent,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(height: 16),
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
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildInfoRow("ID", student.rollNumber),
                      buildInfoRow("Email", student.studentMail),
                      buildInfoRow("Branch", student.branch),
                      buildInfoRow(
                          "Class of", student.graduationYear ?? "202x"),
                      const SizedBox(height: 16),
                      _buildEditableField(
                        "About",
                        aboutController,
                        isEditMode,
                      ),
                      const SizedBox(height: 16),
                      _buildEditableField(
                        "Roles",
                        null,
                        isEditMode,
                        values: student.roles,
                      ),
                      const SizedBox(height: 16),
                      _buildEditableField(
                        "Skills",
                        skillsController,
                        isEditMode,
                      ),
                      const SizedBox(height: 16),
                      buildAchievementsColumn(student.achievements),
                    ],
                  ),
                ),
              ),
            ],
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

  Widget _buildEditableField(
    String title,
    TextEditingController? controller,
    bool isEditable, {
    List<String>? values,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (isEditable) ...[
          if (controller != null) TextField(controller: controller),
          if (values != null) ...[
            for (var value in values) Text('- $value'),
          ]
        ] else ...[
          if (values != null && values.isNotEmpty)
            for (var value in values) Text('- $value'),
          if (values == null || values.isEmpty) const Text('- No Information'),
        ],
      ],
    );
  }

  Widget buildAchievementsColumn(List<Achievement>? achievements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Achievements:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (isEditMode) ...[
          if (achievementsController != null)
            TextField(controller: achievementsController),
        ] else ...[
          if (achievements != null)
            for (var achievement in achievements)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- ${achievement.title}'),
                  Text('  ${achievement.description}'),
                ],
              ),
        ],
      ],
    );
  }

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
}
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