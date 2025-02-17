import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:thesis_scanner/device.dart';
import 'package:thesis_scanner/entry.dart';
import 'package:thesis_scanner/poi.dart';
import 'package:thesis_scanner/theorical_experiment.dart';
import 'package:thesis_scanner/user.dart';

class Experiment {
  final TheoricalExperiment theoricalExperiment;
  final List<Device> devices;
  final List<POI> pois;
  final List<Entry> entries = [];
  int currentStep = -1;
  int currentStepRemainingDuration = 0;
  bool currentStepDurationDecrease = true;

  Experiment(
    this.theoricalExperiment,
    this.devices,
    this.pois,
  );

  get currentStepTitle => theoricalExperiment.steps[currentStep].title;

  void record(User user) {
    final entry = Entry(
      theoricalExperiment,
      DateTime.now(),
      user.X,
      user.Y,
      user.currentPoi,
      user.poiDist,
      currentStep,
    );
    entries.add(entry);
  }

  Future<bool> save() async {
    try {
      const csvHeader = 'xp_name,xp_step,time,x,y,poi,poi_dist\n';
      final csvRows = entries
          .map((entry) =>
              '${entry.theoricalExperiment.name},${entry.step},${entry.time.toIso8601String()},${entry.X},${entry.Y},${entry.poi?.name ?? ""},${entry.poiDist ?? ""}')
          .join('\n');
      final csvContent = csvHeader + csvRows;

      final directory = await getDownloadsDirectory();
      if (directory == null) {
        print('Error getting downloads directory');
        return false;
      }
      final path = '${directory.path}/experiment_data.csv';

      final file = File(path);
      await file.writeAsString(csvContent);

      print('CSV saved to: $path');
      return true;
    } catch (e) {
      print('Error saving CSV: $e');
      return false;
    }
  }
}
