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
    final Map<Device, (int, num, num?)> values = {};

    for (Device device in user.devices) {
      var lastTenRssis = device.rssis.length >= 10
          ? device.rssis.sublist(device.rssis.length - 10)
          : device.rssis;

      if (lastTenRssis.any((rssi) => rssi != null)) {
        int rssi = device.validRssis.last;
        num rawDistance = device.distances.last;
        num? filteredDistance = device.kalmanDistances.lastOrNull;

        values[device] = (rssi, rawDistance, filteredDistance);
      }
    }

    final entry = Entry(
      theoricalExperiment,
      DateTime.now(),
      user.X,
      user.Y,
      user.currentPoi,
      user.poiDist,
      currentStep,
      values,
    );
    entries.add(entry);
  }

  Future<bool> save() async {
    try {
      // Create header with device columns
      final deviceColumns = devices
          .expand((device) =>
              '${device.name}_rssi,${device.name}_raw_dist,${device.name}_filtered_dist'
                  .split(','))
          .join(',');
      final csvHeader =
          'xp_name,xp_step,time,x,y,poi,poi_dist,${deviceColumns}\n';

      // Create rows with device values
      final csvRows = entries.map((entry) {
        final baseData =
            '${entry.theoricalExperiment.name},${entry.step},${entry.time.toIso8601String()},${entry.X},${entry.Y},${entry.poi?.name ?? ""},${entry.poiDist ?? ""}';

        final deviceValues = devices.map((device) {
          final values = entry.values[device];
          return values != null
              ? '${values.$1},${values.$2},${values.$3 ?? ""}'
              : ',,'; // Empty values if no data for this device
        }).join(',');

        return '$baseData,$deviceValues';
      }).join('\n');

      final csvContent = csvHeader + csvRows;

      final directory = await getDownloadsDirectory();
      if (directory == null) {
        print('Error getting downloads directory');
        return false;
      }
      final path =
          '${directory.path}/experiment_data_${theoricalExperiment.name}_${DateTime.now().toIso8601String().replaceAll(':', '-')}.csv';

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
