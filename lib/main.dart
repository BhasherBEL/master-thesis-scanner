import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:thesis_scanner/device.dart';

import 'package:thesis_scanner/pages/list.dart';
import 'package:thesis_scanner/pages/map.dart';

final regions = <Region>[
  Region(identifier: 'Thesis'),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await flutterBeacon.initializeAndCheckScanning;

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

  @override
  void initState() {
    super.initState();
    startBeaconRanging();
  }

  void startBeaconRanging() {
    flutterBeacon.ranging(regions).listen((RangingResult result) {
      setState(() {
        for (Device device in devices) {
          Beacon? beacon = result.beacons.firstWhereOrNull(
            (b) =>
                b.proximityUUID == device.uuid &&
                b.major == device.major &&
                b.minor == device.minor,
          );

          device.addEntry(beacon?.rssi);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Thesis scanner'),
        ),
        body: Column(
          children: [
            if (_currentIndex == 0)
              ListPage(devices: devices)
            else if (_currentIndex == 1)
              MapPage(devices: devices),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
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
              icon: Icon(Icons.map),
              label: 'Map',
            ),
          ],
        ),
      ),
    );
  }
}
