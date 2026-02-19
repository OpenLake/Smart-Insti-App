
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import '../constants/constants.dart';
import 'auth/auth_service.dart';
import '../../provider/auth_provider.dart'; // Import AuthService provider if possible or use Dio directly
import 'package:flutter_riverpod/flutter_riverpod.dart'; // If using provider

// Background handler must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp(); // If needed for other services
  print("Handling a background message: ${message.messageId}");
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
    return NotificationService(ref);
});

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final Logger _logger = Logger();
  final Ref _ref;
  final Dio _client = Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl));

  NotificationService(this._ref);

  Future<void> initialize() async {
    try {
      // Request permission
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _logger.i('User granted permission');
      } else {
          _logger.w('User declined or has not accepted permission');
          return;
      }
    } catch (e) {
      _logger.w("Firebase Messaging initialization failed (likely no config): $e");
      return;
    }

    // Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Foreground Handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.i('Got a message whilst in the foreground!');
      _logger.i('Message data: ${message.data}');

      if (message.notification != null) {
        _logger.i('Message also contained a notification: ${message.notification}');
        _showLocalNotification(message);
      }
    });

    // Token Management
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _syncToken(newToken);
    });

    // Get initial token
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
        _syncToken(token);
    }
    
    // Initialize Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _localNotifications.initialize(settings: initializationSettings);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'high_importance_channel', 
            'High Importance Notifications',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _localNotifications.show(
        id: 0, 
        title: message.notification?.title, 
        body: message.notification?.body, 
        notificationDetails: platformChannelSpecifics,
        payload: 'item x');
  }


  Future<void> _syncToken(String fcmToken) async {
      // We need auth token to register FCM token
      // Assuming AuthService sets global headers or we fetch from secure storage.
      // But standard way using Provider is tricky inside listen without context.
      // We can use secure storage directly or try to access Auth State.
      
      // For simplicity, let's assume we can get the token from SecureStorage same as AuthService
      
      // Or cleaner: AuthProvider should call this service upon login.
      // But for token refresh, we need to know the auth token.
      
      // Let's rely on AuthService having a method to get current token.
      // Or just try to read from storage here if needed.
      
      // Let's try to get auth token via ref if possible or storage.
      // Actually, we can just call an API endpoint.
      
      final authService = _ref.read(authServiceProvider);
      final credentials = await authService.checkCredentials();
      final token = credentials['token'];
      
      if (token != null && token.isNotEmpty) {
           _client.options.headers['authorization'] = 'Bearer $token';
           try {
               await _client.post('/notifications/register-token', data: {'fcmToken': fcmToken});
               _logger.i("FCM Token synced");
           } catch (e) {
               _logger.e("Error syncing FCM token: $e");
           }
      }
  }
}
