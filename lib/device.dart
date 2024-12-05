import 'dart:math';

import 'package:beacon_distance/beacon_distance.dart';
import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';
import 'package:thesis_scanner/utils/kalman.dart';
import 'package:collection/collection.dart';
import 'package:thesis_scanner/utils/rssi2meters.dart';

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
    // Device(
    //   'Thesis-2 - center',
    //   'E5CA1ADE-F007-BA11-0000-000000000000',
    //   208,
    //   62918,
    //   -59,
    //   200,
    //   370,
    //   0.6,
    // ),
    Device(
      'Thesis-1 - Bed',
      'E5CA1ADE-F007-BA11-0000-000000000000',
      40,
      23783,
      -59,
      6,
      5,
      1,
    ),
    // Device(
    //   'Thesis-3 - left',
    //   'E5CA1ADE-F007-BA11-0000-000000000000',
    //   104,
    //   43185,
    //   -59,
    //   30,
    //   10,
    //   1,
    // ),
    Device(
      'Thesis-4 - Door',
      'E5CA1ADE-F007-BA11-0000-000000000000',
      140,
      58820,
      -59,
      0,
      5,
      1,
    ),
    Device(
      'Thesis-5 - TV',
      'E5CA1ADE-F007-BA11-0000-000000000000',
      56,
      48560,
      -59,
      5,
      0,
      1,
    ),
    // Gen 2
    // Device(
    //   'Thesis-6 - center',
    //   'DDE807AE-4D48-5E96-A947-89E4C7E2FD4B',
    //   //'4BFDE2-C7-E489-47A9-965E-484DAE07E8DD'
    //   100,
    //   49494,
    //   -59,
    //   300,
    //   370,
    //   1,
    // ),
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

  List<int> get validRssis {
    return rssis.where((rssi) => rssi != null).map((i) => i!).toList();
  }

  List<num> get distances {
    return validRssis
        .map(
          (rssi) => rssi2meters(rssi, txPower),
        )
        .toList();
  }

  List<num> get kalmanDistances {
    KalmanFilter kf = KalmanFilter(
      0.25,
      1.4,
      0,
      0, //rssis.firstWhereOrNull((r) => r != null)?.toDouble() ?? 0,
    );
    return validRssis
        .map(
          (rssi) => kf.getFilteredValue(
            min(
              20,
              rssi2meters(
                rssi,
                txPower,
              ).toDouble(),
            ),
          ),
        )
        .toList();
  }
}
