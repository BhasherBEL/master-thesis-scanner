import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:thesis_scanner/device.dart';
import 'package:thesis_scanner/pages/debug.dart';
import 'package:thesis_scanner/pages/record.dart';
import 'package:thesis_scanner/poi.dart';
import 'package:thesis_scanner/user.dart';
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
  var user = User(Device.devices, POI.pois);
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
          for (Device device in user.devices) {
            Beacon? beacon = result.beacons.firstWhereOrNull(
              (b) =>
                  b.proximityUUID.toLowerCase() == device.uuid.toLowerCase() &&
                  b.major == device.major &&
                  b.minor == device.minor,
            );

            device.addEntry(beacon?.rssi);
          }
          user.update();
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
          child: _currentIndex == 0
              ? RecordPage(
                  record: record,
                  setRecord: (bool r) {
                    setState(() {
                      record = r;
                    });
                  },
                  user: user,
                )
              : DebugPage(user: user),
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
              icon: Icon(Icons.save),
              label: 'Experiment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Debug',
            ),
          ],
        ),
      ),
    );
  }
}
