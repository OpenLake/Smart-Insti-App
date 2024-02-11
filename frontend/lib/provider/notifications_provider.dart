import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notifications_schema.dart';

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<NotificationModel>>(
  (ref) => NotificationsNotifier(),
);

class NotificationsNotifier extends StateNotifier<List<NotificationModel>> {
  NotificationsNotifier() : super([]);

  void addNotification(String message) {
    state = [...state, NotificationModel(message: 'message1')];
  }

  // Method to generate dummy notifications
  void generateDummyNotifications() {
    addNotification('Notification 1');
    addNotification('Notification 2');
    addNotification('Notification 3');
  }
}
