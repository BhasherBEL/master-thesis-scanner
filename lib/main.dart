import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:thesis_scanner/consts.dart';

import 'package:thesis_scanner/device.dart';
import 'package:thesis_scanner/pages/debug.dart';
import 'package:thesis_scanner/pages/list.dart';
import 'package:thesis_scanner/pages/record.dart';
import 'package:thesis_scanner/poi.dart';
import 'package:thesis_scanner/user.dart';
import 'package:thesis_scanner/utils/logging.dart';
import 'package:thesis_scanner/utils/mqtt.dart';

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
      home: Builder(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Smart visit of Musée L'),
                actions: <Widget>[
                  PopupMenuButton<String>(
                    onSelected: (String value) {
                      setState(() {
                        switch (value) {
                          case 'debug':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DebugPage(),
                              ),
                            );
                            break;
                          case 'experiment':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => RecordPage(
                                      record: record,
                                      setRecord: (bool r) {
                                        setState(() {
                                          record = r;
                                        });
                                      },
                                      user: user,
                                    ),
                              ),
                            );
                            break;
                          default:
                            break;
                        }
                      });
                    },
                    itemBuilder:
                        (context) => const [
                          PopupMenuItem(
                            value: 'experiment',
                            child: Text('Experiment'),
                          ),
                          PopupMenuItem(value: 'debug', child: Text('Debug')),
                        ],
                  ),
                ],
              ),
              body: const ListPage(),
            ),
      ),
    );
  }
}
