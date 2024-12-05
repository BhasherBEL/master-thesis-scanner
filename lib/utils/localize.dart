import 'dart:math';

import 'package:thesis_scanner/device.dart';

Map<T, double> getNBiggestValues<T>(Map<T, double> map, int n) {
  final sortedEntries = map.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return Map.fromEntries(sortedEntries.take(n));
}

(num, num) localize(List<Device> devices) {
  Map<Device, double> distances = {};

  for (var device in devices) {
    distances[device] = device.kalmanDistances.last.toDouble();
  }

  distances = getNBiggestValues(distances, 3);

  List<(num, num, num)> p =
      distances.entries.map((e) => (e.key.X, e.key.Y, e.value)).toList();

  num a = (-2 * p[0].$1) + (2 * p[1].$1);
  num b = (-2 * p[0].$2) + (2 * p[1].$2);
  num c = pow(p[0].$3, 2) -
      pow(p[1].$3, 2) -
      pow(p[0].$1, 2) +
      pow(p[1].$1, 2) -
      pow(p[0].$2, 2) +
      pow(p[1].$2, 2);

  num d = (-2 * p[1].$1) + (2 * p[2].$1);
  num e = (-2 * p[1].$2) + (2 * p[2].$2);
  num f = pow(p[1].$3, 2) -
      pow(p[2].$3, 2) -
      pow(p[1].$1, 2) +
      pow(p[2].$1, 2) -
      pow(p[1].$2, 2) +
      pow(p[2].$2, 2);

  num x = (c * e - f * b) / (e * a - b * d);
  num y = (c * d - a * f) / (b * d - a * e);

  return (x, y);
}
