import "dart:isolate";

import "package:frontend/util/network.dart";
import "package:frontend/util/notification.dart";

void setEnterAlarm(SendPort sendPort) {
  final receivePort = ReceivePort();

  receivePort.listen((msg) async {
    while (true) {
      int position = await httpGet("/group/index"); // TODO: 서버 주소 입력

      if (position < 2) {
        FNotification.showNotification("입장 알림", "이제 입장해주세요.");
        msg[0].send(true);
        break;
      }
    }
  });
}
