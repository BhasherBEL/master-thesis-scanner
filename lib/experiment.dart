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
  final currentStep = 0;
  final currentStepRemainingDuration = 0;
  final currentStepDurationDecrease = true;

  Experiment(
    this.theoricalExperiment,
    this.devices,
    this.pois,
  );

  void record(User user) {
    final entry =
        Entry(DateTime.now(), user.X, user.Y, user.currentPoi, user.poiDist);
    entries.add(entry);
  }

  bool save() {
    try {
      // Generate the CSV content
      const csvHeader = 'Timestamp,X,Y,POI,POI Distance\n';
      final csvRows = entries
          .map((entry) =>
              '${entry.time.toIso8601String()},${entry.X},${entry.Y},${entry.poi?.name ?? ""},${entry.poiDist ?? ""}')
          .join('\n');
      final csvContent = csvHeader + csvRows;

      // Get temporary directory to store the file temporarily
      // Note: We don't delete the temp file immediately as it's needed for sharing
      // The system will clean up temporary files automatically

      return true;
    } catch (e) {
      print('Error sharing CSV: $e');
      return false;
    }
  }
}
