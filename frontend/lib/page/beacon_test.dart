import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:beacon_scanner/beacon_scanner.dart";

bool beacon1 = false;
bool beacon2 = false;

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
                  await Permission.backgroundRefresh.request();
                  await Permission.ignoreBatteryOptimizations.request();

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
                    streamRanging = scanner.ranging(region).listen((result) {
                      debugPrint(result.beacons.join('\n'));
                      debugPrint(
                          "--------------------------------------------");

                      if (result.beacons
                          .where((beacon) =>
                              beacon.macAddress ==
                                  "00:C0:B1:C0:44:BB" &&
                              beacon.rssi > -40) // TODO: 신호 감도 조정 필요
                          .isNotEmpty) {
                        setState(() {
                          beacon1 = true;
                        });
                      }
                      if (beacon1 && result.beacons
                          .where((beacon) =>
                              beacon.macAddress ==
                                  "00:C0:B1:C0:44:C0" &&
                              beacon.rssi > -40) // TODO: 신호 감도 조정 필요
                          .isNotEmpty) {
                        setState(() {
                          beacon2 = true;
                        });
                      }
                    });
                  } else {
                    await openAppSettings();
                  }
                },
                child: const Text("스캔"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    streamRanging.cancel();
                    beacon1 = false;
                    beacon2 = false;
                  });
                },
                child: const Text("스캔 중지"),
              ),
              Text(beacon1 ? "1번 비콘 감지" : " "),
              Text(beacon2 ? "2번 비콘 감지" : " "),
            ],
          )),
    );
  }
}
