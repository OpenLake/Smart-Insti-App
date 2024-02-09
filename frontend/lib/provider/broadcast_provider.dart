import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_insti_app/models/broadcast_schema.dart';

final broadcastProvider = FutureProvider<List<Broadcast>>((ref) async {
  await Future.delayed(const Duration(seconds: 2)); // Simulating delay
  return List.generate(
      10,
      (index) => Broadcast(
            title: 'Broadcast $index',
            body: 'This is the body of broadcast $index.',
            time: DateTime.now(),
          ));
});
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:smart_insti_app/models/broadcast_schema.dart';
// import '../repositories/broadcast_repository.dart';

// final broadcastProvider = FutureProvider<List<Broadcast>>((ref) async {
//   final repository = ref.read(broadcastRepositoryProvider);
//   return repository.fetchBroadcasts();
// });
