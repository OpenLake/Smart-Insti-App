import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constants.dart';
import '../routes/student_provide.dart';
// import '../screens/user_profile.dart';

class Home extends ConsumerWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.read(studentProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            AppConstants.appName,
          ),
          backgroundColor: Colors.lightBlueAccent,
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                context.push('/user_profile');
              },
            ),
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () {
                context.push('/admin_home');
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Welcome, ${student.name}!',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Tap the icon to view your profile.'),
            ],
          ),
        ),
      ),
    );
  }
}


// class Home extends ConsumerWidget {
//   const Home({Key? key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final student = ref.read(studentProvider);

//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             AppConstants.appName,
//             // style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           backgroundColor: Colors.lightBlueAccent,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       context.push('/user_profile');
//                     },
//                     child: Container(
//                       width: 50,
//                       height: 50,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.lightBlue,
//                       ),
//                       child: const Icon(
//                         Icons.person,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'Welcome, ${student.name}!',
//                 style:
//                     const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               const Text('Tap the icon to view your profile.'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
