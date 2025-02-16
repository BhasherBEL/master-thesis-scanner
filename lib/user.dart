import 'dart:math';

import 'package:thesis_scanner/device.dart';
import 'package:thesis_scanner/entry.dart';
import 'package:thesis_scanner/poi.dart';
import 'package:thesis_scanner/utils/localize.dart';

class User {
  final List<Device> devices;
  final List<POI> pois;
  num X = 0;
  num Y = 0;
  final List<Entry> entries = [];

  POI? currentPoi;
  num? poiDist;
  int poiCount = 0;

  User(
    this.devices,
    this.pois,
  );

  void update() {
    updateLocation();
    updatePoi();
    record();
  }

  void updateLocation() {
    var (x, y) = localize(devices);
    X = x;
    Y = y;
  }

  void updatePoi() {
    for (var poi in pois) {
      final distance = sqrt(pow(X - poi.X, 2) + pow(Y - poi.Y, 2));

      if (currentPoi == poi && distance > poi.radiusOut) {
        currentPoi = null;
        poiDist = null;
        poiCount = 0;
        continue;
      }

      if (distance <= poi.radiusIn) {
        if (currentPoi == poi) {
          poiCount++;
          poiDist = distance;
        } else if (currentPoi == null) {
          currentPoi = poi;
          poiDist = distance;
          poiCount = 1;
        }
      }
    }
  }

  void record() {
    final entry = Entry(DateTime.now(), X, Y, currentPoi, poiDist);
    entries.add(entry);
    // print('${currentPoi?.name}: $poiCount, $poiDist');
  }
}
