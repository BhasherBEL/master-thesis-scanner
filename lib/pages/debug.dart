import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:thesis_scanner/device.dart';
import 'package:thesis_scanner/poi.dart';
import 'package:thesis_scanner/utils/localize.dart';
import 'package:thesis_scanner/widgets/locmap.dart';

class DebugPage extends StatelessWidget {
  final List<Device> devices;
  final List<POI> pois;

  const DebugPage({required this.devices, required this.pois, super.key});

  static Map<Color, String> colors = {
    Colors.red: 'red',
    Colors.blue: 'blue',
    Colors.green: 'green',
    Colors.purple: 'purple',
    Colors.orange: 'orange',
    Colors.lime: 'lime',
  };

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return const Text(
        'No beacon detected',
        textAlign: TextAlign.center,
      );
    }

    /*if (devices.every((device) => device.validRssis.isEmpty)) {
      return const Text(
        "No data",
        textAlign: TextAlign.center,
      );
    }*/

    var (x, y) = localize(devices);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Estimated position",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)}",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: LocMap(
            width: 11,
            height: 12.5,
            userPosition: Offset(x.toDouble(), y.toDouble()),
            devices: devices,
            colors: colors,
            pois: pois,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Colors",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < devices.length; index++)
                Text(
                    '${devices[index].name}: ${colors.values.elementAt(index % colors.length)}'),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "RSSIs (DBm)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 300,
          child: LineChart(
            LineChartData(
              lineBarsData: devices
                  .asMap()
                  .entries
                  .map(
                    (d) => LineChartBarData(
                      color: colors.keys.elementAt(d.key % colors.length),
                      spots: d.value.validRssis.reversed
                          .take(20)
                          .toList()
                          .reversed
                          .toList()
                          .asMap()
                          .entries
                          .map(
                            (e) => FlSpot(
                              e.key.toDouble(),
                              e.value.toDouble(),
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Raw distances (m)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        ClipRect(
          child: SizedBox(
            width: double.infinity,
            height: 300,
            child: LineChart(
              LineChartData(
                maxY: 15,
                minY: 0,
                lineBarsData: devices
                    .asMap()
                    .entries
                    .map(
                      (d) => LineChartBarData(
                        color: colors.keys.elementAt(d.key % colors.length),
                        preventCurveOverShooting: true,
                        spots: d.value.distances.reversed
                            .take(20)
                            .toList()
                            .reversed
                            .toList()
                            .asMap()
                            .entries
                            .map(
                              (e) => FlSpot(
                                e.key.toDouble(),
                                e.value.toDouble(),
                              ),
                            )
                            .toList(),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Filtered distances (m)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        ClipRect(
          child: SizedBox(
            width: double.infinity,
            height: 300,
            child: LineChart(
              LineChartData(
                maxY: 15,
                minY: 0,
                lineBarsData: devices
                    .asMap()
                    .entries
                    .map(
                      (d) => LineChartBarData(
                        color: colors.keys.elementAt(d.key % colors.length),
                        preventCurveOverShooting: true,
                        spots: d.value.kalmanDistances.reversed
                            .take(20)
                            .toList()
                            .reversed
                            .toList()
                            .asMap()
                            .entries
                            .map(
                              (e) => FlSpot(
                                e.key.toDouble(),
                                e.value.toDouble(),
                              ),
                            )
                            .toList(),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
