import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:beacon_scanner/beacon_scanner.dart";

class BeaconTestPageWidget extends StatefulWidget {
  const BeaconTestPageWidget({super.key});

  @override
  State<BeaconTestPageWidget> createState() => _BeaconTestPageWidgetState();
}

class _BeaconTestPageWidgetState extends State<BeaconTestPageWidget> {
  final beaconScanner = BeaconScanner.instance;
  var streamRanging;

  @override
  Widget build(BuildContext context) {
    final scanner = BeaconScanner.instance;
    final region = <Region>[];

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  await Permission.notification.request();
                  await Permission.locationAlways.request();
                  await Permission.bluetooth.request();
                  await Permission.bluetoothScan.request();
                  await Permission.bluetoothConnect.request();
                  await Permission.nearbyWifiDevices.request();

                  try {
                    await scanner.initialize(true);
                  } on PlatformException catch (e) {
                    debugPrint("Failed to initialize");
                  }

                  region.add(const Region(
                    identifier: "CCE00BED-E080-04C4-1A91-1A1A29B64111",
                  ));
                },
                child: const Text("초기화"),
              ),
              TextButton(
                onPressed: () async {
                  if (await Permission.bluetoothScan.isGranted |
                      await Permission.bluetoothScan.isLimited |
                      await Permission.bluetoothScan.isProvisional) {
                    streamRanging =
                        scanner.ranging(region).listen((result) {
                      debugPrint(result.beacons.join('\n'));
                      debugPrint(
                          "--------------------------------------------");
                    });
                  } else {
                    await openAppSettings();
                  }
                },
                child: const Text("스캔"),
              ),
              TextButton(
                onPressed: () {
                  streamRanging.cancel();
                },
                child: const Text("스캔 중지"),
              )
            ],
          )),
    );
  }
}
