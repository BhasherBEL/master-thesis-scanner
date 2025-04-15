import 'dart:math';

num N = 2.83;

num rssi2meters(num rssi, num tx) {
  return pow(10, -(rssi - tx) / (10 * N));
}
