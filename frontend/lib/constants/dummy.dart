// import '../screens/user_profile.dart';
import '../models/student2.dart';

// class DummyStudents {
//   static Student getStudentById(String id) {
//     return students.firstWhere(
//       (student) => student.id == id,
//       orElse: () => Student(
//         id: '1',
//         name: 'John Doe',
//         studentMail: 'john.doe@example.com',
//         rollNumber: '12345678',
//         about: 'Hi, I am a CSE Undergrad of IIT BHOPAL.',
//         profilePicURI:
//             'https://cdn4.sharechat.com/img_907710_35cec5f5_1681916904360_sc.jpg?tenant=sc&referrer=pwa-sharechat-service&f=360_sc.jpg',
//         graduationYear: '2026',
//         branch: 'Computer Science',
//         roles: ['Openlake Core Member', 'Class Representative'],
//         skills: ['Flutter', 'Dart'],
//         achievements: [
//           Achievement(
//             title: 'Hackathon Winner',
//             description: 'First place in XYZ Hackathon',
//           ),
//           Achievement(
//             title: 'Project Showcase',
//             description: 'Presented a project at ABC Expo',
//           ),
//         ],
//       ),
//     );
//   }

//   static List<Student> students = [
//     // Existing students...
//     // Add more students with skills and achievements as needed
//   ];
// }
class DummyStudents {
  static List<Student> students = [
    Student(
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
    ),
    Student(
      id: '2',
      name: 'Talla',
      studentMail: 'talla.doe@example.com',
      rollNumber: '12345789',
      about: 'Hi , i am a CSE Undergrad of IIT BHOjpur.',
      profilePicURI:
          'https://cdn4.sharechat.com/img_907710_35cec5f5_1681916904360_sc.jpg?tenant=sc&referrer=pwa-sharechat-service&f=360_sc.jpg',
      graduationYear: '2025',
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
    ),
  ];
}
