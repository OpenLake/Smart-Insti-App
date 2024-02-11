import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_insti_app/components/menu_tile.dart';
import '../constants/constants.dart';
import '../provider/student_provider.dart';
import '../provider/room_provider.dart';
import '../screens/notifications.dart';

class Home extends ConsumerWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.read(studentProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppConstants.appName,
          ),
          backgroundColor: Colors.lightBlueAccent,
          actions: [
            // Icon for Notifications Page
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Navigate to notifications page
                context.push('/notifications');
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                context.push('/user_profile');
              },
            ),
            IconButton(
              icon: Icon(Icons.admin_panel_settings),
              onPressed: () {
                context.push('/admin_home');
              },
            ),
          ],
        ),
        body: GridView.count(
          padding: const EdgeInsets.all(10),
          crossAxisCount: 2,
          children: [
            MenuTile(
              title: 'Room\nVacancy',
              onTap: () => context.push('/home/classroom_vacancy'),
              body: [
                SizedBox(height: 5),
                Consumer(
                  builder: (_, ref, __) => Text(
                    '${ref.read(roomProvider.notifier).getVacantCount()} Vacant',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
              icon: Icons.class_,
              primaryColor: Colors.lightBlueAccent.shade100,
              secondaryColor: Colors.lightBlueAccent.shade200,
            ),
            MenuTile(
              title: "Lost\n&\nFound",
              onTap: () => context.push('/home/lost_and_found'),
              primaryColor: Colors.orangeAccent.shade100,
              secondaryColor: Colors.orangeAccent.shade200,
              icon: Icons.search,
            ),
            MenuTile(
              title: 'Broadcast',
              onTap: () {
                // Navigate to the broadcast page
                context.push('/broadcast');
              },
              icon: Icons.announcement,
              primaryColor: Colors.greenAccent.shade100,
              secondaryColor: Colors.greenAccent.shade200,
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:smart_insti_app/components/menu_tile.dart';
// import '../constants/constants.dart';
// import '../provider/student_provider.dart';

// import '../provider/room_provider.dart';

// class Home extends ConsumerWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final student = ref.read(studentProvider);
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             AppConstants.appName,
//           ),
//           backgroundColor: Colors.lightBlueAccent,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.person),
//               onPressed: () {
//                 context.push('/user_profile');
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.admin_panel_settings),
//               onPressed: () {
//                 context.push('/admin_home');
//               },
//             ),
//           ],
//         ),
//         body: GridView.count(
//           padding: const EdgeInsets.all(10),
//           crossAxisCount: 2,
//           children: [
//             MenuTile(
//               title: 'Room\nVacancy',
//               onTap: () => context.push('/home/classroom_vacancy'),
//               body: [
//                 const SizedBox(height: 5),
//                 Consumer(
//                   builder: (_, ref, __) => Text(
//                     '${ref.read(roomProvider.notifier).getVacantCount()} Vacant',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                 ),
//               ],
//               icon: Icons.class_,
//               primaryColor: Colors.lightBlueAccent.shade100,
//               secondaryColor: Colors.lightBlueAccent.shade200,
//             ),
//             MenuTile(
//                 title: "Lost\n&\nFound",
//                 onTap: () => context.push('/home/lost_and_found'),
//                 primaryColor: Colors.orangeAccent.shade100,
//                 secondaryColor: Colors.orangeAccent.shade200,
//                 icon: Icons.search),
//             MenuTile(
//               title: 'Broadcast',
//               onTap: () {
//                 // Navigate to the broadcast page
//                 context.push('/broadcast');
//               },
//               icon: Icons.announcement,
//               primaryColor: Colors.greenAccent.shade100,
//               secondaryColor: Colors.greenAccent.shade200,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

