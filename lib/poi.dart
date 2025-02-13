import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:thesis_scanner/device.dart';

class POI {
  int id;
  double X;
  double Y;
  double radiusIn;
  double radiusOut;
  String name;
  String color;

  static final pois = <POI>[];

  static void addOrUpdatePOI(POI poi) {
    int index = pois.indexWhere((p) => p.id == poi.id);
    if (index != -1) {
      pois[index].X = poi.X;
      pois[index].Y = poi.Y;
      pois[index].radiusIn = poi.radiusIn;
      pois[index].radiusOut = poi.radiusOut;
      pois[index].name = poi.name;
      pois[index].color = poi.color;
    } else {
      pois.add(poi);
    }
  }

  POI(
    this.id,
    this.X,
    this.Y,
    this.radiusIn,
    this.radiusOut,
    this.name,
    this.color,
  );

  double getDistance(Device d) {
    return sqrt(pow(d.X - X, 2) + pow(d.Y - Y, 2));
  }

  Color getColor() {
    if (color == 'red') {
      return Colors.red;
    }

    return Colors.grey;
  }
}
