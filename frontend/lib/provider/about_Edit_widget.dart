import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../provider/student_provider.dart';

final aboutProvider = Provider<String?>((ref) {
  return ref.watch(aboutControllerProvider);
});

final aboutControllerProvider =
    StateNotifierProvider<AboutController, String?>((ref) {
  return AboutController();
});

class AboutController extends StateNotifier<String?> {
  AboutController() : super("");

  void updateAbout(String about) {
    state = about;
  }
}

class AboutEditWidget extends ConsumerWidget {
  const AboutEditWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final about = ref.watch(aboutProvider);

    final TextEditingController aboutController =
        TextEditingController(text: about);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: aboutController,
          onChanged: (newAbout) {
            ref.read(aboutControllerProvider.notifier).updateAbout(newAbout);
          },
          decoration: const InputDecoration(
            hintText: 'Write something about yourself...',
          ),
          maxLines: 5,
        ),
      ],
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../provider/student_provider.dart';

// class AboutEditorWidget extends ConsumerWidget {
//   const AboutEditorWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final student = ref.read(studentProvider);

//     final TextEditingController aboutController =
//         TextEditingController(text: student.about);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'About',
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         TextFormField(
//           controller: aboutController,
//           onChanged: (newAbout) {
//             ref.read(studentProvider.notifier).editAbout(newAbout);
//           },
//           decoration: const InputDecoration(
//             hintText: 'Write something about yourself...',
//           ),
//           maxLines: 5,
//         ),
//       ],
//     );
//   }
// }
// // class AboutEditorWidget extends ConsumerWidget {
// //   const AboutEditorWidget({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final student = ref.read(studentProvider);

// //     final TextEditingController aboutController =
// //         TextEditingController(text: student.about);

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           'About',
// //           style: const TextStyle(
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         TextField(
// //           controller: aboutController,
// //           onChanged: (newAbout) {
// //             ref.read(studentProvider.notifier).editAbout(newAbout);
// //           },
// //           decoration: const InputDecoration(
// //             hintText: 'Write something about yourself...',
// //           ),
// //           maxLines: 5,
// //         ),
// //       ],
// //     );
// //   }
// // }
