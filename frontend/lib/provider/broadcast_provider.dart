import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_insti_app/models/broadcast_schema.dart';
import '../repositories/broadcast_repository.dart';

final broadcastProvider = FutureProvider<List<Broadcast>>((ref) async {
  final repository = ref.read(broadcastRepositoryProvider);
  return repository.fetchBroadcasts();
});
