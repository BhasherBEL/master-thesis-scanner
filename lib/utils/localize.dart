import 'package:thesis_scanner/device.dart';
import 'package:trotter/trotter.dart';
import 'dart:math';

Map<T, double> getNBiggestValues<T>(Map<T, double> map, int n) {
  final sortedEntries = map.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return Map.fromEntries(sortedEntries.take(n));
}

Map<T, double> getNLowestValues<T>(Map<T, double> map, int n) {
  final sortedEntries = map.entries.toList()
    ..sort((a, b) => a.value.compareTo(b.value));
  return Map.fromEntries(sortedEntries.take(n));
}

(num, num) localize(List<Device> devices) {
  Map<Device, double> distances = {};

  for (var device in devices) {
    if (device.kalmanDistances.isNotEmpty) {
      var lastTenRssis = device.rssis.length >= 10
          ? device.rssis.sublist(device.rssis.length - 10)
          : device.rssis;

      if (lastTenRssis.any((rssi) => rssi != null)) {
        distances[device] = device.kalmanDistances.last.toDouble();
      }
    }
  }

  if (distances.length < 3) {
    return (0, 0);
  }

  // (X, Y, weight)
  List<(num, num, num)> localizations = [];

  distances = getNLowestValues(distances, 6);

  var combinations = Combinations(3, distances.entries.toList());
  for (final combination in combinations()) {
    List<(num, num, num)> apData =
        combination.map((e) => (e.key.X, e.key.Y, e.value)).toList();

    num centroidX = (apData[0].$1 + apData[1].$1 + apData[2].$1) / 3;
    num centroidY = (apData[0].$2 + apData[1].$2 + apData[2].$2) / 3;

    List<num> ratios = [
      apData[1].$3 / apData[0].$3,
      apData[2].$3 / apData[1].$3,
      apData[0].$3 / apData[2].$3
    ];

    num xOffset = ((apData[0].$1 - centroidX) * ratios[0] +
            (apData[1].$1 - centroidX) * ratios[1] +
            (apData[2].$1 - centroidX) * ratios[2]) /
        3;

    num yOffset = ((apData[0].$2 - centroidY) * ratios[0] +
            (apData[1].$2 - centroidY) * ratios[1] +
            (apData[2].$2 - centroidY) * ratios[2]) /
        3;

    num x = (centroidX + xOffset);
    num y = (centroidY + yOffset);

    localizations.add((
      x,
      y,
      calculateTriangleQuality(apData[0].$1, apData[0].$2, apData[1].$1,
          apData[1].$2, apData[2].$1, apData[2].$2)
    ));
  }

  num finalX = 0, finalY = 0, totalWeight = 0;

  for (final localization in localizations) {
    finalX += localization.$1 * localization.$3;
    finalY += localization.$2 * localization.$3;
    totalWeight += localization.$3;
  }

  num x = finalX / totalWeight;
  num y = finalY / totalWeight;

  return (x, y);
}

double calculateTriangleQuality(
    num x1, num y1, num x2, num y2, num x3, num y3) {
  // Compute side lengths
  double a = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  double b = sqrt(pow(x3 - x2, 2) + pow(y3 - y2, 2));
  double c = sqrt(pow(x1 - x3, 2) + pow(y1 - y3, 2));

  // Heron's formula for area
  double s = (a + b + c) / 2;
  double area = sqrt(s * (s - a) * (s - b) * (s - c));

  // Check for degenerate triangle (collinear points)
  if (area < 1e-6) return 0; // Very low quality

  // Compute angles using cosine rule
  double cosAngle1 = (b * b + c * c - a * a) / (2 * b * c);
  double cosAngle2 = (a * a + c * c - b * b) / (2 * a * c);
  double cosAngle3 = (a * a + b * b - c * c) / (2 * a * b);

  // Convert cosines to degrees
  double angle1 = acos(cosAngle1) * 180 / pi;
  double angle2 = acos(cosAngle2) * 180 / pi;
  double angle3 = acos(cosAngle3) * 180 / pi;

  // Angle quality: Penalize extreme angles
  double angleQuality = (angle1 >= 30 && angle1 <= 120 ? 1 : 0) +
      (angle2 >= 30 && angle2 <= 120 ? 1 : 0) +
      (angle3 >= 30 && angle3 <= 120 ? 1 : 0);
  angleQuality /= 3; // Normalize to [0, 1]

  // Normalize area (assume max area in the environment is known, e.g., 100)
  double normalizedArea = area / 100;

  // Weighted quality score
  double w1 = 0.7; // Weight for area
  double w2 = 0.3; // Weight for angle quality
  return w1 * normalizedArea + w2 * angleQuality;
}
