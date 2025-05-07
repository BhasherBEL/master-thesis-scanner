import 'dart:math';

import 'package:beacon_distance/beacon_distance.dart';
import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';
import 'package:thesis_scanner/utils/kalman.dart';
import 'package:thesis_scanner/utils/rssi2meters.dart';

class Device {
  final String name;
  String uuid;
  int major;
  int minor;
  int txPower;
  double X;
  double Y;
  double am;

  static final devices = <Device>[];

  static void addDevice(Device device) {
    devices.removeWhere((d) => d.name == device.name);
    devices.add(device);
  }

  static void addOrUpdateDevice(Device device) {
    int index = devices.indexWhere((d) => d.name == device.name);
    if (index != -1) {
      devices[index].uuid = device.uuid;
      devices[index].major = device.major;
      devices[index].minor = device.minor;
      devices[index].txPower = -69; // device.txPower;
      devices[index].X = device.X;
      devices[index].Y = device.Y;
      devices[index].am = device.am;
    } else {
      devices.add(device);
    }
  }

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

    double avgDistance = BeaconUtil.instance.calculateDistance(
      txPower,
      avgRssi,
    );

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
    return validRssis.map((rssi) => rssi2meters(rssi, txPower)).toList();
  }

  List<num> get kalmanDistances {
    KalmanFilter kf = KalmanFilter(
      0.1,
      //0.25,
      3.5,
      0,
      15, //rssis.firstWhereOrNull((r) => r != null)?.toDouble() ?? 0,
    );
    return validRssis
        .map(
          (rssi) => kf.getFilteredValue(
            min(20, rssi2meters(rssi, txPower).toDouble()),
          ),
        )
        .toList();
  }
}
