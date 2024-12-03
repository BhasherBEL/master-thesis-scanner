import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thesis_scanner/device.dart';

class RecordPage extends StatefulWidget {
  final List<Device> devices;
  final bool record;
  final Function(bool r) setRecord;

  const RecordPage({
    required this.devices,
    required this.record,
    required this.setRecord,
    super.key,
  });

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  bool isRecording = false;
  int timeRemaining = 30;

  startRecording() {
    setState(() {
      isRecording = true;
      for (var device in widget.devices) {
        device.rssis.clear();
      }

      widget.setRecord(true);

      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          timeRemaining--;
        });
        if (timeRemaining <= 0) {
          timer.cancel();
          setState(() {
            isRecording = false;
            timeRemaining = 30;
            widget.setRecord(false);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
        child: Column(
          children: [
            OutlinedButton(
              child: Text(
                widget.record
                    ? 'Stop system recording'
                    : 'Start system recording',
              ),
              onPressed: () => widget.setRecord(!widget.record),
            ),
            OutlinedButton(
              child: const Text('Clear system recording'),
              onPressed: () {
                setState(() {
                  for (var device in widget.devices) {
                    device.rssis.clear();
                  }
                });
              },
            ),
            OutlinedButton(
              onPressed: isRecording ? null : startRecording,
              child: const Text('Start timed recording'),
            ),
            Text(
              'Recording state: ${widget.record ? 'enabled' : 'disabled'}',
            ),
            Text('Time remaining: $timeRemaining'),
          ],
        ),
      ),
      ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.devices.length,
        itemBuilder: (context, index) {
          Device device = widget.devices[index];

          var (rssi, n, miss, distance) =
              device.getAverageDistance(10000, 10000);

          return ListTile(
            title: Text(
              '${device.name} - ${device.major}#${device.minor}',
            ),
            subtitle: Text(
              '${distance?.toStringAsFixed(5)}m (${rssi.toStringAsFixed(5)}/${device.txPower})',
            ),
            trailing: Text(
              '$n/${n + miss}',
            ),
          );
        },
      ),
    ]);
  }
}
