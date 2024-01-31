import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student2.dart';

final studentProvider = Provider<Student>((ref) => Student(
      id: '1',
      name: 'John Doe',
      studentMail: 'john.doe@example.com',
      rollNumber: '12345678',
      about: 'Hi , i am a CSE Undergrad of IIT BHOPAL.',
      profilePicURI:
          'https://cdn4.sharechat.com/img_907710_35cec5f5_1681916904360_sc.jpg?tenant=sc&referrer=pwa-sharechat-service&f=360_sc.jpg',
      graduationYear: '2026',
      branch: 'Computer Science',
      roles: ['Openlake Core Member', 'Class Representative'],
      skills: ['Flutter', 'Dart'],
      achievements: [
        Achievement(
          title: 'Hackathon Winner',
          description: 'First place in XYZ Hackathon',
        ),
        Achievement(
          title: 'Project Showcase',
          description: 'Presented a project at ABC Expo',
        ),
      ],
    ));
