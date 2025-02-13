import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thesis_scanner/device.dart';
import 'package:thesis_scanner/poi.dart';

class LocMap extends StatelessWidget {
  final double width;
  final double height;
  final Offset userPosition;
  final List<Device> devices;
  final Map<Color, String> colors;
  final List<POI> pois;

  const LocMap({
    super.key,
    required this.width,
    required this.height,
    required this.userPosition,
    required this.devices,
    required this.colors,
    required this.pois,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AspectRatio(
        aspectRatio: width / height,
        child: CustomPaint(
          painter: RoomPainter(
            width: width,
            height: height,
            userPosition: userPosition,
            devices: devices,
            colors: colors,
            pois: pois,
          ),
        ),
      ),
    );
  }
}

class RoomPainter extends CustomPainter {
  final double width;
  final double height;
  final Offset userPosition;
  final List<Device> devices;
  final Map<Color, String> colors;
  final List<POI> pois;

  RoomPainter({
    required this.width,
    required this.height,
    required this.userPosition,
    required this.devices,
    required this.colors,
    required this.pois,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint roomPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint userPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      roomPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      borderPaint,
    );

    double scaleX = size.width / width;
    double scaleY = size.height / height;

    Offset mapToScreen(Offset point) =>
        Offset(point.dx * scaleX, size.height - (point.dy * scaleY));

    final userScreenPosition = mapToScreen(userPosition);
    canvas.drawCircle(userScreenPosition, 10, userPaint);

    int i = 0;
    for (final device in devices) {
      final Paint beaconPaint = Paint()
        ..color = colors.keys.elementAt(i % colors.length)
        ..style = PaintingStyle.fill;

      final Paint beaconDistPaint = Paint()
        ..color = colors.keys.elementAt(i % colors.length)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      final p = mapToScreen(Offset(device.X, device.Y));
      canvas.drawCircle(p, 5, beaconPaint);

      if (device.kalmanDistances.isNotEmpty) {
        final d = device.kalmanDistances.last.toDouble();
        final size = Size(d * scaleX * 2, d * scaleY * 2);

        canvas.drawOval(
          Offset(p.dx - size.height / 2, p.dy - size.width / 2) & size,
          beaconDistPaint,
        );
      }
      i++;
    }

    for (final poi in pois) {
      final Paint poiPaint = Paint()
        ..color = poi.getColor()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final p = mapToScreen(Offset(poi.X, poi.Y));
      const crossSize = 6.0;
      const angle = 45 * 3.14159 / 180;

      canvas.drawLine(
        Offset(p.dx - crossSize * cos(angle), p.dy - crossSize * sin(angle)),
        Offset(p.dx + crossSize * cos(angle), p.dy + crossSize * sin(angle)),
        poiPaint,
      );
      canvas.drawLine(
        Offset(p.dx - crossSize * sin(angle), p.dy + crossSize * cos(angle)),
        Offset(p.dx + crossSize * sin(angle), p.dy - crossSize * cos(angle)),
        poiPaint,
      );

      final Paint poiRadiusInPaint = Paint()
        ..color = Colors.green.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      final Paint poiRadiusOutPaint = Paint()
        ..color = Colors.red.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      final sizeIn = Size(poi.radiusIn * scaleX * 2, poi.radiusIn * scaleY * 2);
      final sizeOut =
          Size(poi.radiusOut * scaleX * 2, poi.radiusOut * scaleY * 2);

      canvas.drawOval(
        Offset(p.dx - sizeIn.width / 2, p.dy - sizeIn.height / 2) & sizeIn,
        poiRadiusInPaint,
      );

      canvas.drawOval(
        Offset(p.dx - sizeOut.width / 2, p.dy - sizeOut.height / 2) & sizeOut,
        poiRadiusOutPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
