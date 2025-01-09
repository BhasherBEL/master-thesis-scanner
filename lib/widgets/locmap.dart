import 'package:flutter/material.dart';
import 'package:thesis_scanner/device.dart';

class LocMap extends StatelessWidget {
  final double width;
  final double height;
  final Offset userPosition;
  final List<Device> devices;
  final Map<Color, String> colors;

  const LocMap({
    super.key,
    required this.width,
    required this.height,
    required this.userPosition,
    required this.devices,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: width / height,
      child: CustomPaint(
        painter: RoomPainter(
          width: width,
          height: height,
          userPosition: userPosition,
          devices: devices,
          colors: colors,
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

  RoomPainter({
    required this.width,
    required this.height,
    required this.userPosition,
    required this.devices,
    required this.colors,
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
        Offset(point.dx * scaleX, point.dy * scaleY);

    final userScreenPosition = mapToScreen(userPosition);
    canvas.drawCircle(userScreenPosition, 10, userPaint);

    int i = 0;
    for (final device in devices) {
      if (device.name == "ESP32-2") {
        print("${device.X} ${device.Y}");
      }
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
