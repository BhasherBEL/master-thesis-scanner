import 'dart:math';

num N = 3.5;

num rssi2meters(num rssi, num tx) {
  return pow(10, -(rssi - tx) / (10 * N));
}
