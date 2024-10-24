import 'package:firebase_messaging/firebase_messaging.dart';
import '../features/home/presentation/home_page.dart';
import '../main.dart';

class PushNotificationApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Initialize push notifications
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    initPushNotifications();
  }

  Future<void> handler(RemoteMessage message) async {
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Payload: ${message.data}');
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _firebaseMessaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handler);
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      HomePage.routeName,
      arguments: message,
    );
  }
}
