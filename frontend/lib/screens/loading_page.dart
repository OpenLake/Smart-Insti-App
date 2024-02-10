import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import 'package:smart_insti_app/services/auth/auth_service.dart';

class LoadingPage extends ConsumerWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        body: FutureBuilder<Map<String, String>>(
          future: ref.read(authServiceProvider).checkCredentials(),
          // future: null,
          builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
            if (snapshot.data?['role'] == 'admin') {
              ref.read(authProvider.notifier).getCurrentUser();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/admin');
              });
              return Container();
            } else if (snapshot.data?['role'] == 'student' || snapshot.data?['role'] == 'faculty') {
              ref.read(authProvider.notifier).getCurrentUser();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/home');
              });
              return Container();
            } else if (snapshot.data?['role'] == '') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/login');
              });
              return Container();
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Smart Insti App', style: TextStyle(fontSize: 45, fontFamily: 'Jost')),
                    Padding(
                      padding: const EdgeInsets.only(left: 184.0),
                      child: Row(
                        children: [
                          const Text('Loading', style: TextStyle(fontSize: 30, fontFamily: 'Jost')),
                          AnimatedTextKit(
                            isRepeatingAnimation: true,
                            repeatForever: true,
                            animatedTexts: [
                              TyperAnimatedText(
                                '...',
                                speed: const Duration(milliseconds: 100),
                                textStyle: const TextStyle(fontSize: 30, fontFamily: 'Jost'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
