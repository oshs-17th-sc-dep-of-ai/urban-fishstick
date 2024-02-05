// https://velog.io/@osung/Flutter-%EC%9D%B4%EB%B2%A4%ED%8A%B8-%EB%A3%A8%ED%94%84Event-Loop%EC%99%80-isolate

import "dart:isolate";
import "package:frontend/util/network.dart";

void main() async {
  final receivePort = ReceivePort();
  Isolate.spawn(echoIsolate, receivePort.sendPort);

  final echoIsolateSendPort = await receivePort.first;
  final response = ReceivePort();

  echoIsolateSendPort.send(['hello', response.sendPort]);
  print(await response.first);
}

void echoIsolate(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  receivePort.listen((msg) {
    final data = msg[0];

    SendPort to = msg[1];
    to.send("Echo from isolate: $data");
  });
}