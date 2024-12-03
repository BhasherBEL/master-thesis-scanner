import 'package:flutter/material.dart';
import 'package:thesis_scanner/device.dart';

class ListPage extends StatelessWidget {
  final List<Device> devices;

  const ListPage({required this.devices, super.key});

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return const Text(
        'No beacon detected',
        textAlign: TextAlign.center,
      );
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: devices.length,
      itemBuilder: (context, index) {
        Device device = devices[index];

        var (rssi, n, miss, distance) = device.getAverageDistance();

        return ListTile(
          title: Text(
            '${device.name} - ${device.major}#${device.minor}',
          ),
          subtitle: Text(
            '${distance?.toStringAsFixed(2)}m (${rssi.toStringAsFixed(2)}/${device.txPower})',
          ),
          trailing: Text(
            '$n/${n + miss}',
          ),
        );
      },
    );
  }
}
