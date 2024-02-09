import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_insti_app/provider/broadcast_provider.dart';
import 'package:smart_insti_app/models/broadcast_schema.dart';

class BroadcastPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcasts = ref.watch(broadcastProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Broadcasts'),
      ),
      body: broadcasts.when(
        data: (broadcasts) {
          return ListView.builder(
            itemCount: broadcasts.length,
            itemBuilder: (context, index) {
              final broadcast = broadcasts[index];
              return ListTile(
                title: Text(broadcast.title),
                subtitle: Text(broadcast.body),
                trailing: Text(
                  '${broadcast.time.hour}:${broadcast.time.minute}',
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
