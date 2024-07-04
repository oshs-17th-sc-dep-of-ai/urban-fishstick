import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/util/beacon.dart';
import 'package:permission_handler/permission_handler.dart';

bool beacon1 = false;
bool beacon2 = false;

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
                  BeaconUtil().init(12345);
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
                  if (await Permission.bluetoothScan.isGranted |
                      await Permission.bluetoothScan.isLimited |
                      await Permission.bluetoothScan.isProvisional) {
                    BeaconUtil().startScan();
                  } else {
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
