import "dart:io";

import "package:flutter/services.dart";

import "package:frontend/util/network.dart";
import "package:frontend/util/notification.dart";

void checkQueuePositionWithPolling(Map<String, dynamic> M) async {
  RootIsolateToken rootIsolateToken = M["token"];
  int studentID = M["student_id"];

  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

  int queuePosition =
      await httpGet("http://localhost:8720/group/index?sid=$studentID");
  while (queuePosition > 5) {
    queuePosition =
        await httpGet("http://localhost:8720/group/index?sid=$studentID");
    sleep(const Duration(seconds: 10));
  }

  FNotification.showNotification("입장 알림", "이제 입장해주세요");
}
