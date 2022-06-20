import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsServices {
  static Future<void> initialize() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('notification init');
    }
  }
}
