import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/student_provider.dart';

class AboutEditorWidget extends ConsumerWidget {
  const AboutEditorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.read(studentProvider);

    final TextEditingController aboutController =
        TextEditingController(text: student.about);

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
            ref.read(studentProvider.notifier).editAbout(newAbout);
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
