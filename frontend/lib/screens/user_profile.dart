import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/edit_profile.dart';
import '../provider/student_provider.dart';
import '../models/achievement.dart';
import '../models/student.dart';

class UserProfile extends ConsumerWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.read(studentProvider);
    final Student? currentStudent = student.getStudentById('1');

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
                CircleAvatar(
                  backgroundImage: currentStudent?.profilePicURI != null
                      ? NetworkImage(currentStudent!.profilePicURI!)
                      : const AssetImage('assets/openlake.png')
                          as ImageProvider<Object>,
                  radius: 55,
                  child: currentStudent?.profilePicURI == null
                      ? const Icon(
                          Icons.person,
                          size: 55,
                          color: Colors.grey,
                        )
                      : null,
                ),

                const SizedBox(height: 8),

                Text(
                  currentStudent?.name ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 8),

                // User Details Card
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5,
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildInfoRow(
                                "ID", currentStudent?.rollNumber ?? ''),
                            buildInfoRow("Email", currentStudent?.email ?? ''),
                            buildInfoRow(
                                "Branch", currentStudent?.branch ?? ''),
                            buildInfoRow("Class of",
                                "${currentStudent?.graduationYear}" ?? ''),
                            const SizedBox(height: 16),
                            const Text(
                              'About:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(currentStudent?.about ?? 'No information'),

                            const SizedBox(height: 5),

                            const Text(
                              'Roles: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                                '${currentStudent?.roles?.join(", ") ?? "No roles"}'),
                            // style: TextStyle(),)

                            const SizedBox(height: 16),

                            const Text(
                              'Skills:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),

                            if (currentStudent?.skills != null)
                              Column(
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: currentStudent!.skills!
                                          .map(
                                            (skill) => SizedBox(
                                              width: 105,
                                              height: 80,
                                              child: PieChart(
                                                PieChartData(
                                                  sections: [
                                                    PieChartSectionData(
                                                      value: skill.level
                                                          .toDouble(),
                                                      title: skill.name,
                                                      color: getRandomColor(),
                                                    ),
                                                    PieChartSectionData(
                                                      value: (100 - skill.level)
                                                          .toDouble(),
                                                      title: '',
                                                      color: Color.fromARGB(
                                                          255, 184, 212, 240),
                                                    ),
                                                  ],
                                                  sectionsSpace: 0,
                                                  centerSpaceRadius: 0,
                                                  borderData: FlBorderData(
                                                    show: false,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Slider(
                                    value: 10,
                                    onChanged: (double value) {},
                                    min: 0,
                                    max: 100,
                                  ),
                                ],
                              ),

                            const SizedBox(height: 5),

                            const Text(
                              'Achievements:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: currentStudent?.achievements
                                        ?.map(
                                          (achievement) => SizedBox(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    48 -
                                                    40) /
                                                2,
                                            child: buildAchievementCard(
                                                achievement),
                                          ),
                                        )
                                        .toList() ??
                                    [],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Slider(
                              value: 10,
                              onChanged: (double value) {},
                              min: 0,
                              max: 100,
                              divisions: 5,
                              label: 'Achievement Slider',
                            ),
                          ],
                        ),
                      ),
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
                fontSize: 15,
              ),
            ),
            // const SizedBox(height: 8),
            Text(
              'Date: ${achievement.date}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              achievement.description,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Color getRandomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }
}
