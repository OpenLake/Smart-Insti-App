import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/notifications_provider.dart';

class NotificationsPage extends ConsumerWidget with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read notifications from the provider
    final notifications = ref.watch(notificationsProvider);

    // Generate dummy notifications when the page is first built
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ref.read(notificationsProvider.notifier).generateDummyNotifications();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            title: Text(notification.message),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../provider/notifications_provider.dart';

// class NotificationsPage extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Read notifications from the provider
//     final notifications = ref.watch(notificationsProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notifications'),
//       ),
//       body: ListView.builder(
//         itemCount: notifications.length,
//         itemBuilder: (context, index) {
//           final notification = notifications[index];
//           return ListTile(
//             title: Text(notification.message),
//           );
//         },
//       ),
//     );
//   }
// }
