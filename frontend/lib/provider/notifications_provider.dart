import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notifications_schema.dart';

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<NotificationModel>>(
  (ref) => NotificationsNotifier(),
);

class NotificationsNotifier extends StateNotifier<List<NotificationModel>> {
  NotificationsNotifier() : super([]);

  void addNotification(String message, DateTime date) {
    state = [
      ...state,
      NotificationModel(message: message, date: date ?? DateTime.now())
    ];
  }

  // Method to generate dummy notifications
  void generateDummyNotifications() {
    addNotification('Notification 1', DateTime(2004, 9, 7, 17, 30));
    addNotification('Notification 2', DateTime(2004, 9, 8, 9, 45));
    addNotification('Notification 3', DateTime(2004, 9, 9, 12, 0));
    addNotification('Notification 4', DateTime(2004, 9, 7, 17, 30));
    addNotification('Notification 5', DateTime(2004, 9, 8, 9, 45));
    addNotification('Notification 6', DateTime(2004, 9, 9, 12, 0));
    addNotification('Notification 7', DateTime(2004, 9, 7, 17, 30));
    addNotification('Notification 8', DateTime(2004, 9, 8, 9, 45));
    addNotification('Notification 9', DateTime(2004, 9, 9, 12, 0));
  }
}
