import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/util/beacon.dart';
import 'package:permission_handler/permission_handler.dart';

bool enterBeaconDetected = false;
bool exitBeaconDetected = false;

class BeaconTestPageWidget extends StatefulWidget {
  const BeaconTestPageWidget({super.key});

  @override
  State<BeaconTestPageWidget> createState() => _BeaconTestPageWidgetState();
}

class _BeaconTestPageWidgetState extends State<BeaconTestPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  BeaconUtil().init();

                  await Permission.location.request();
                  await Permission.locationAlways.request();
                  await Permission.bluetooth.request();
                  await Permission.bluetoothScan.request();
                  await Permission.notification.request();
                },
                child: const Text("초기화"),
              ),
              TextButton(
                onPressed: () async {
                  if (await Permission.bluetoothScan.isGranted) {
                    BeaconUtil().startScan();
                  } else {
                    await Fluttertoast.showToast(
                        msg: "위치 액세스 권한을 항상 허용으로 변경해주세요",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    await openAppSettings();
                  }
                },
                child: const Text("스캔"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    BeaconUtil().stopScan();
                  });
                },
                child: const Text("스캔 중지"),
              ),
            ],
          )),
    );
  }
}
