import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FNotification {
  FNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false; // 초기화 상태를 추적하는 변수

  static init() async {
    // TODO: iOS 설정 초기화
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings("mipmap/ic_launcher");

    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _isInitialized = true; // 초기화가 완료되면 true로 설정
  }

  static Future<void> showNotification(String title, String body) async {
    // 초기화가 완료되지 않으면 기다린다
    if (!_isInitialized) {
      await Future.delayed(Duration(seconds: 1)); // 잠시 대기
      return showNotification(title, body); // 다시 호출
    }

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("os_lunch", "입장 알림",
            channelDescription: "입장 순서 알림",
            importance: Importance.max,
            priority: Priority.max,
            showWhen: true);

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        1024, title, body, notificationDetails); // 1024: 알림 아이디, 아무 숫자로 해놓았음.
  }
}
