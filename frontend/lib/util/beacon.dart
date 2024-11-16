import "dart:async";

import "package:beacon_scanner/beacon_scanner.dart";

class BeaconUtil {
  BeaconUtil._();

  static final BeaconUtil _instance = BeaconUtil._();
  static final BeaconScanner beaconScanner = BeaconScanner.instance;

  final enterBeaconMACAddress = "00C0B1C044BA";
  final exitBeaconMACAddress = "00C0B1C044C1";

  bool enterBeaconDetected = false;
  bool exitBeaconDetected = false;

  final regions = <Region>[
    const Region(
      identifier: "CCE99BED-E080-04C4-1A91-1A1A29B64112",
    )
  ];

  factory BeaconUtil() {
    return _instance;
  }

  void init() async {
    await beaconScanner.initialize(true);
  }

  Future<StreamSubscription<ScanResult>> startScan() async {
    return beaconScanner.ranging(regions).listen((ScanResult result) {
      for (var beacon in result.beacons) {
        if (beacon.macAddress == BeaconUtil().enterBeaconMACAddress) {
          BeaconUtil().enterBeaconDetected = true;
        } else if (BeaconUtil().enterBeaconDetected &&
            beacon.macAddress == BeaconUtil().exitBeaconMACAddress) {
          BeaconUtil().exitBeaconDetected = true;
        }
      }
    });
  }

  void stopScan() async {
    beaconScanner.close();
  }
}
