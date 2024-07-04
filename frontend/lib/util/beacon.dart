import "dart:convert";
import "dart:developer";

import "package:flutter/services.dart";
import "package:frontend/util/network.dart";

class BeaconUtil {
  BeaconUtil._();

  static final BeaconUtil _instance = BeaconUtil._();
  static const _messageChannel = BasicMessageChannel("org.oshssc.oslunch/message", StringCodec());

  bool enterBeaconDetected = false;
  bool exitBeaconDetected = false;
  int? studentID;

  factory BeaconUtil() {
    log("init");
    return _instance;
  }

  void init(int studentID) {
    this.studentID = studentID;

    _messageChannel.setMessageHandler((String? message) async {
      switch (message) {
        case "enterBeaconDetected": {
          enterBeaconDetected = true;
          await httpPost("http://localhost:8720/seat/enter", jsonEncode(studentID));  // TODO: 주소 변경
          log("test");
          return message!;
        }
        case "exitBeaconDetected": {
          exitBeaconDetected = enterBeaconDetected;
          await httpPost("http://localhost:8720/seat/exit", jsonEncode(studentID));  // TODO: 주소 변경
          return message!;
        }
        case _: {
          return "";
        }
      }
    });
  }

  void startScan() async {
    _messageChannel.send("startScan");
    log("startScan");
  }

  void stopScan() async {
    _messageChannel.send("stopScan");
  }
}
