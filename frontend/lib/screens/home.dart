import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_insti_app/components/menu_tile.dart';
import 'package:smart_insti_app/models/student.dart';
import '../components/collapsing_app_bar.dart';
import '../constants/constants.dart';
import '../models/faculty.dart';
import '../provider/auth_provider.dart';
import '../provider/room_provider.dart';
import '../services/auth/auth_service.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider.notifier).tokenCheckProgress != LoadingState.progress && context.mounted) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(context, AuthConstants.generalAuthLabel.toLowerCase());
      }
    });
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CollapsingAppBar(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 45,
                        fontFamily: "RobotoFlex",
                      ),
                    ),
                    Consumer(
                      builder: (_, ref, __) {
                        if (ref.read(authProvider).currentUser != null) {
                          return AnimatedTextKit(
                            repeatForever: true,
                            pause: const Duration(milliseconds: 1500),
                            animatedTexts: [
                              TyperAnimatedText(
                                ref.read(authProvider).currentUserRole!.replaceFirst(
                                    ref.read(authProvider).currentUserRole![0],
                                    ref.read(authProvider).currentUserRole![0].toUpperCase()),
                                textStyle: const TextStyle(fontSize: 45, fontFamily: "RobotoFlex"),
                                speed: const Duration(milliseconds: 300),
                              ),
                              TyperAnimatedText(
                                ref.read(authProvider).currentUserRole == "student"
                                    ? (ref.read(authProvider).currentUser as Student).name.split(" ").first
                                    : (ref.read(authProvider).currentUser as Faculty).name.split(" ").first,
                                textStyle: const TextStyle(
                                    fontSize: 45, fontFamily: "RobotoFlex", overflow: TextOverflow.ellipsis),
                                speed: const Duration(milliseconds: 300),
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    )
                  ],
                ),
              ),
              bottom: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Consumer(
                  builder: (_, ref, ___) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                value: "about",
                                child: const Text("About"),
                                onTap: () => showAboutDialog(
                                  context: context,
                                  children: [
                                    const Text("Smart Insti App"),
                                    const Text(
                                        "This app aims to solve the day-to-day problems that students and faculty face in IIT Bhilai and aims to consolidate a lot of useful applications into single app. This could include features like Time Table, Classroom Vacancy, Lost and Found, Chatrooms on various topics like Internet Issues. It could also have a broadcast feature which would be very useful in emergency situations."),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: "logout",
                                child: const Text("Log Out"),
                                onTap: () {
                                  ref.read(authServiceProvider).clearCredentials();
                                  ref.read(authProvider.notifier).clearCurrentUser();
                                  context.go('/');
                                },
                              ),
                            ];
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
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
                      '${ref.watch(roomProvider).roomList.where((element) => element.vacant).length} Vacant',
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
      ),
    );
  }
}
