import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/models/faculty.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';

import '../../constants/constants.dart';

class FacultyProfile extends ConsumerWidget {
  const FacultyProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider.notifier).tokenCheckProgress != LoadingState.progress && context.mounted) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(context, AuthConstants.generalAuthLabel.toLowerCase());
      }
    });

    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        body: Consumer(builder: (_, ref, __) {
          if (ref.read(authProvider).currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            Faculty currentFaculty = ref.read(authProvider).currentUser as Faculty;
            return Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Faculty Profile', style: TextStyle(fontSize: 35, fontFamily: 'Jost')),
                    const SizedBox(height: 20),
                    MaterialTextFormField(
                        hintText: "Faculty Name", enabled: false, controllerLessValue: currentFaculty.name),
                    const SizedBox(height: 20),
                    MaterialTextFormField(
                        hintText: "Faculty Email", enabled: false, controllerLessValue: currentFaculty.email),
                    const SizedBox(height: 20),
                    if (currentFaculty.cabin != null)
                      MaterialTextFormField(
                          hintText: "Faculty Cabin", enabled: false, controllerLessValue: currentFaculty.cabin),
                    if (currentFaculty.department != null)
                      MaterialTextFormField(
                          hintText: "Faculty Department",
                          enabled: false,
                          controllerLessValue: currentFaculty.department),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
