import 'package:flutter/material.dart';
import 'package:thesis_scanner/device.dart';
import 'package:thesis_scanner/widgets/circle_painter.dart';

class MapPage extends StatelessWidget {
  final List<Device> devices;

  const MapPage({required this.devices, super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double imageWidth = 590;
    double imageHeight = 375;
    double realRate = screenWidth / imageWidth;

    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          InteractiveViewer(
            minScale: 0.1,
            maxScale: 5,
            child: SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: Stack(
                children: [
                  Image.asset('assets/map.png'),
                  for (var device in devices)
                    Builder(
                      builder: (context) {
                        final textPainter = TextPainter(
                          text: TextSpan(
                            text: device.name,
                          ),
                          textDirection: TextDirection.ltr,
                        )..layout();

                        final textWidth = textPainter.width;
                        final textHeight = textPainter.height + 32;

                        return Positioned(
                          left: realRate * device.X - textWidth / 2,
                          top: realRate * device.Y - textHeight / 2,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.bluetooth, size: 32),
                                  Text(device.name),
                                ],
                              ),
                              CustomPaint(
                                painter: CirclePainter(
                                  radius: device.getAverageDistanceOnly() *
                                      100 *
                                      realRate *
                                      device.am,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
