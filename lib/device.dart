import 'package:beacon_distance/beacon_distance.dart';
import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';

class Device {
  final String uuid;
  final int major;
  final int minor;
  final int? txPower;

  List<int?> rssis = [];

  Device(
    this.uuid,
    this.major,
    this.minor,
    this.txPower,
  );

  static Device createFromBeacon(Beacon beacon) {
    Device device = Device(
      beacon.proximityUUID,
      beacon.major,
      beacon.minor,
      beacon.txPower,
    );

    return device;
  }

  bool compare(Beacon beacon) {
    return uuid == beacon.proximityUUID &&
        major == beacon.major &&
        minor == beacon.minor &&
        txPower == beacon.txPower;
  }

  void addEntry(int? rssi) {
    rssis.add(rssi);
  }

  (double, int, int, double?) getAverageDistance([int n = 5, int max = 10]) {
    List<int?> subRssis =
        rssis.length > 10 ? rssis.sublist(rssis.length - max) : rssis;

    List<int> nRssis = [];

    int realN = 0;
    int miss = 0;

    for (int? rssi in subRssis) {
      if (rssi == null) {
        miss++;
        continue;
      }
      nRssis.add(rssi);
      realN++;
      if (realN >= n) break;
    }

    if (realN == 0) return (0, realN, miss, null);

    double avgRssi = nRssis.reduce((a, b) => a + b) / realN;

    double? avgDistance = txPower != null
        ? BeaconUtil.instance.calculateDistance(txPower!, avgRssi)
        : null;

    return (avgRssi, realN, miss, avgDistance);
  }

  String getName() {
    if (major == 104) return 'Poteau 2';
    if (major == 40) return 'Poteau 1';
    if (major == 208) return 'Desk';
    return 'Unknown';
  }
}
