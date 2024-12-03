import 'package:beacon_distance/beacon_distance.dart';
import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';

class Device {
  final String name;
  final String uuid;
  final int major;
  final int minor;
  final int txPower;
  final double X;
  final double Y;
  final double am;

  static final devices = <Device>[
    Device(
      'Thesis-2 - center',
      'E5CA1ADE-F007-BA11-0000-000000000000',
      208,
      62918,
      -59,
      200,
      370,
      0.6,
    ),
    Device(
      'Thesis-1 - right',
      'E5CA1ADE-F007-BA11-0000-000000000000',
      40,
      23783,
      -59,
      380,
      10,
      1,
    ),
    Device(
      'Thesis-3 - left',
      'E5CA1ADE-F007-BA11-0000-000000000000',
      104,
      43185,
      -59,
      30,
      10,
      1,
    ),
    Device(
      'Thesis-4 - door',
      'E5CA1ADE-F007-BA11-0000-000000000000',
      140,
      58820,
      -59,
      550,
      260,
      1,
    ),
    Device(
      'Thesis-5 - poteau',
      'E5CA1ADE-F007-BA11-0000-000000000000',
      56,
      48560,
      -59,
      750,
      270,
      1,
    ),
  ];

  List<int?> rssis = [];

  Device(
    this.name,
    this.uuid,
    this.major,
    this.minor,
    this.txPower,
    this.X,
    this.Y,
    this.am,
  );

  bool compare(Beacon beacon) {
    return uuid == beacon.proximityUUID &&
        major == beacon.major &&
        minor == beacon.minor &&
        txPower == beacon.txPower;
  }

  void addEntry(int? rssi) {
    rssis.add(rssi);
  }

  (double, int, int, double) getAverageDistance([int n = 5, int max = 10]) {
    List<int?> subRssis =
        rssis.length > max ? rssis.sublist(rssis.length - max) : rssis;

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

    if (realN == 0) return (0, realN, miss, -1.0);

    double avgRssi = nRssis.reduce((a, b) => a + b) / realN;

    double avgDistance =
        BeaconUtil.instance.calculateDistance(txPower, avgRssi);

    return (avgRssi, realN, miss, avgDistance);
  }

  double getAverageDistanceOnly([int n = 5, int max = 10]) {
    var (_, _, _, dst) = getAverageDistance(n, max);
    return dst;
  }
}
