import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:responsive_framework/responsive_framework.dart';

class TimetableEditor extends ConsumerStatefulWidget {
  const TimetableEditor({super.key});

  @override
  ConsumerState<TimetableEditor> createState() => _TimetableEditorState();
}

class _TimetableEditorState extends ConsumerState<TimetableEditor> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    });
      child: Scaffold(
        floatingActionButton: SizedBox(
          width: 35,
          height: 35,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                // context.push('/user_home/room_vacancy');
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        body: Container(
          color: Colors.green,
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(20),
            constrained: true,
            child: Container(
              color: Colors.blue,
              child: Row(
                children: [
                  Column(
                    children: [
                      for (int i = 0; i < 10; i++)
                        Container(
                          width: 100,
                          height: 100,
                          color: Colors.red,
                          child: Center(
                            child: Text(
                              'Column $i',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
