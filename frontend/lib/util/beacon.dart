import 'dart:async';

import 'package:beacon_scanner/beacon_scanner.dart';

bool enterBeaconDetected = false;
bool exitBeaconDetected = false;

class BeaconUtil {
  static final BeaconUtil _instance = BeaconUtil._constructor();

  BeaconUtil._constructor();

  final beaconScanner = BeaconScanner.instance;
  final region = <Region>[];
  StreamSubscription<ScanResult>? ranging;

  factory BeaconUtil() {
    return _instance;
  }

  void init() async {
    await beaconScanner.initialize(true);
    region.add(const Region(
      identifier: "CCE00BED-E080-04C4-1A91-1A1A29B64111",
    ));
  }

  void scan(String enterBeaconMACAddress, String exitBeaconMACAddress) {
    ranging = beaconScanner.ranging(region).listen((result) {
      if (result.beacons
          .where((beacon) =>
              beacon.macAddress == enterBeaconMACAddress &&
              beacon.rssi > -40) // TODO: 신호 감도 조정 필요
          .isNotEmpty) {
        enterBeaconDetected = true;
      }
      if (enterBeaconDetected &&
          result.beacons
              .where((beacon) =>
                  beacon.macAddress == exitBeaconMACAddress &&
                  beacon.rssi > -40) // TODO: 신호 감도 조정 필요
              .isNotEmpty) {
        exitBeaconDetected = true;
        ranging!.cancel();
      }
    });
  }

  void stopScan() {
    if (ranging != null) {
      ranging!.cancel();
    }
  }
}
