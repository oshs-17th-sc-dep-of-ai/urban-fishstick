import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FNotification {
  FNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static init() async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings("mipmap/ic_launcher");

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channel id", "channel name",
          channelDescription: "channel description",
          importance: Importance.max,
          priority: Priority.max,
          showWhen: true
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0, "test title", "test body", notificationDetails);
  }
}