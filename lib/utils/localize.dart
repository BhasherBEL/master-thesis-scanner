import 'package:thesis_scanner/device.dart';

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

  distances = getNLowestValues(distances, 3);

  List<(num, num, num)> apData =
      distances.entries.map((e) => (e.key.X, e.key.Y, e.value)).toList();

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

  return (centroidX + xOffset, centroidY + yOffset);
}
