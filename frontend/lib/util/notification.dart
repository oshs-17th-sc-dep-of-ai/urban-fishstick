import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FNotification {
  FNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false; // 초기화 상태를 추적하는 변수

  static Future<void> init() async {
    if (_isInitialized) return; //이미 초기화된 경우 바로 리턴

    // TODO: iOS 설정 초기화
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings("mipmap/ic_launcher");

    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    try {
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
      _isInitialized = true; // 초기화가 완료되면 true로 설정
      print("Notification plugin initialized successfully");
    } catch (e) {
      print("Notificaion initialization failed: $e");
    }
  }

  static Future<void> showNotification(String title, String body) async {
    // 초기화가 완료되지 않으면 초기화 시도
    if (!_isInitialized) {
      print("Notification plugin not initialized. Attempting to initialize...");
      await init();

      //초기화 또 실패하면 알림 중단
      if (!_isInitialized) {
        print(
            "Notification plugin initialization failed. Cannot show notification.");
        return;
      }
    }

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("os_lunch", "입장 알림",
            channelDescription: "입장 순서 알림",
            importance: Importance.max,
            priority: Priority.max,
            showWhen: true);

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    try {
      await flutterLocalNotificationsPlugin.show(
          1024, title, body, notificationDetails); // 1024: 알림 아이디, 아무 숫자로 해놓았음.
    } catch (e) {
      print("Failed to display notification: $e");
    }
  }
}
