import "package:flutter/material.dart";
import "package:flutter_background/flutter_background.dart";

class BackgroundTestWidget extends StatelessWidget {
  const BackgroundTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () async {
                  const androidConfig = FlutterBackgroundAndroidConfig(
                    notificationTitle: "flutter_background example app",
                    notificationText:
                        "Background notification for keeping the example app running in the background",
                    notificationImportance:
                        AndroidNotificationImportance.Default,
                    notificationIcon: AndroidResource(
                      name: 'background_icon',
                      defType: 'drawable',
                    ), // Default is ic_launcher from folder mipmap
                  );
                  bool success = await FlutterBackground.initialize(
                    androidConfig: androidConfig,
                  );
                  if (success) {
                    debugPrint("success");
                  }
                  bool isRunning =
                      await FlutterBackground.enableBackgroundExecution();
                  if (isRunning) {
                    debugPrint("running");
                  }
                },
                child: const Text("초기화")),
            TextButton(
                onPressed: () {
                  FlutterBackground.enableBackgroundExecution();
                },
                child: const Text("백그라운드 실행")),
            TextButton(
                onPressed: () {
                  FlutterBackground.disableBackgroundExecution();
                },
                child: const Text("백그라운드 실행 중지")),
          ],
        ),
      ),
    );
  }
}
