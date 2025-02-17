import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thesis_scanner/device.dart';
import 'package:thesis_scanner/entry.dart';
import 'package:thesis_scanner/experiment.dart';
import 'package:thesis_scanner/poi.dart';
import 'package:thesis_scanner/theorical_experiment.dart';
import 'package:thesis_scanner/utils/localize.dart';

class User extends ChangeNotifier {
  final List<Device> devices;
  final List<POI> pois;
  num X = 0;
  num Y = 0;
  final List<Entry> entries = [];
  final List<Experiment> experiments = [];
  Experiment? experiment;

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
    if (experiment != null) {
      experiment?.record(this);
      notifyListeners();
    }
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

  void startExperiment(TheoricalExperiment theoricalExperiment) {
    entries.clear();
    experiment = Experiment(theoricalExperiment, devices, pois);
    print('Experiment started: ${theoricalExperiment.name}');
    notifyListeners();
  }

  void endExperiment() {
    if (experiment != null) {
      experiments.add(experiment!);
      print('Experiment ended: ${experiment!.theoricalExperiment.name}');
      experiment = null;
      notifyListeners();
    }
  }

  void cancelExperiment() {
    if (experiment != null) {
      experiment = null;
      notifyListeners();
    }
  }
}
