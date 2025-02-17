import 'package:thesis_scanner/poi.dart';
import 'package:thesis_scanner/theorical_experiment.dart';

class Entry {
  final TheoricalExperiment theoricalExperiment;
  final DateTime time;
  final num X;
  final num Y;
  final POI? poi;
  final num? poiDist;
  final int step;

  Entry(this.theoricalExperiment, this.time, this.X, this.Y, this.poi,
      this.poiDist, this.step);
}
