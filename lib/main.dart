import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thesis_scanner/audio_manager.dart';
import 'package:thesis_scanner/consts.dart';

import 'package:thesis_scanner/device.dart';
import 'package:thesis_scanner/pages/debug.dart';
import 'package:thesis_scanner/pages/list.dart';
import 'package:thesis_scanner/pages/record.dart';
import 'package:thesis_scanner/utils/logging.dart';
import 'package:thesis_scanner/utils/mqtt.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLogging();
  AudioManager().init();

  runApp(const MyApp());

  await localization.init();
  await mqttConnect('scanner_app');
}

class Localization extends ChangeNotifier {
  bool isEnabled = false;

  Future<void> init() async {
    try {
      await askBluetooth();
      await flutterBeacon.initializeAndCheckScanning;
    } on PlatformException catch (e) {
      print('-------------- ERROR ON LOC INIT --------------');
      print(e);
      print('-------------- END ERROR --------------');
    }
  }

  Future<void> askBluetooth() async {
    if (await Permission.bluetoothConnect.isDenied) {
      isEnabled = await Permission.bluetoothConnect.request().isGranted;
      print('ASKED:');
      print(isEnabled);
    } else {
      isEnabled = await Permission.bluetoothScan.isGranted;
      print('ALREADY:');
      print(isEnabled);
    }
    notifyListeners();
  }

  void startBeaconRanging() {
    if (!isEnabled) return;

    flutterBeacon.ranging(regions).listen((RangingResult result) {
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
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var record = true;

  @override
  void initState() {
    super.initState();
    localization.startBeaconRanging();
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
