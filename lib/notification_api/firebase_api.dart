import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> handleForegroundMessage(RemoteMessage message) async {
    print('Title (Foreground): ${message.notification?.title}');
    print('Body (Foreground): ${message.notification?.body}');
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Title (Background): ${message.notification?.title}');
    print('Body (Background): ${message.notification?.body}');
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();

    print('FCM Token: $fcmToken');

    if (FirebaseMessaging.onBackgroundMessage == null) {
      FirebaseMessaging.onBackgroundMessage((message) async {
        await Firebase.initializeApp();
        handleBackgroundMessage(message);
      });
    }

    FirebaseMessaging.onMessage.listen((message) {
      handleForegroundMessage(message);
    });
  }
}
