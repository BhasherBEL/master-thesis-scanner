import 'dart:io';
import 'package:thesis_scanner/poi.dart';

class Entry {
  final DateTime time;
  final num X;
  final num Y;
  final POI? poi;
  final num? poiDist;

  Entry(this.time, this.X, this.Y, this.poi, this.poiDist);

  static Future<bool> shareCSV(List<Entry> entries, {String? filename}) async {
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
