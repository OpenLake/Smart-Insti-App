import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/notifications_provider.dart';
import '../models/notifications_schema.dart';

class NotificationsPage extends ConsumerWidget with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ref.read(notificationsProvider.notifier).generateDummyNotifications();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: notifications.length > 9 ? 9 : notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(
                notification.message,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _formatDateTime(notification.date),
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }

  // Function to format DateTime object to display in ListTile
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}
