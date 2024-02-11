import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_insti_app/components/menu_tile.dart';
import '../constants/constants.dart';
import '../provider/room_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppConstants.appName),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: GridView.count(
          padding: const EdgeInsets.all(10),
          crossAxisCount: 2,
          children: [
            MenuTile(
              title: 'Room\nVacancy',
              onTap: () => context.push('/home/classroom_vacancy'),
              body: [
                const SizedBox(height: 5),
                Consumer(
                  builder: (_, ref, __) => Text(
                    '${ref.read(roomProvider.notifier).getVacantCount()} Vacant',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
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
                icon: Icons.search),
          ],
        ),
      ),
    );
  }
}
