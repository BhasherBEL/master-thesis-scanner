import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:thesis_scanner/device.dart';
import 'package:thesis_scanner/pages/chart.dart';
import 'package:thesis_scanner/pages/list.dart';
import 'package:thesis_scanner/pages/map.dart';
import 'package:thesis_scanner/pages/record.dart';
import 'package:thesis_scanner/utils/logging.dart';
import 'package:thesis_scanner/utils/mqtt.dart';

final regions = <Region>[
  Region(identifier: 'Thesis'),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await flutterBeacon.initializeAndCheckScanning;
  await initLogging();
  await mqttConnect('scanner_app');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 1;
  var devices = Device.devices;
  var record = true;
  bool arePermissionsGranted = false;
  bool isBluetoothEnabled = false;

  @override
  void initState() {
    super.initState();
    startBeaconRanging();
  }

  void startBeaconRanging() {
    flutterBeacon.ranging(regions).listen((RangingResult result) {
      if (record) {
        setState(() {
          for (Device device in devices) {
            Beacon? beacon = result.beacons.firstWhereOrNull(
              (b) =>
                  b.proximityUUID.toLowerCase() == device.uuid.toLowerCase() &&
                  b.major == device.major &&
                  b.minor == device.minor,
            );

            device.addEntry(beacon?.rssi);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Thesis scanner'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (_currentIndex == 0)
                ListPage(devices: devices)
              else if (_currentIndex == 1)
                ChartPage(devices: devices)
              else if (_currentIndex == 2)
                MapPage(devices: devices)
              else if (_currentIndex == 3)
                RecordPage(
                  devices: devices,
                  record: record,
                  setRecord: (bool r) {
                    setState(() {
                      record = r;
                    });
                  },
                ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Charts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.save),
              label: 'Record',
            ),
          ],
        ),
      ),
    );
  }
}
