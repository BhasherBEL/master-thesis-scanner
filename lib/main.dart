import 'dart:convert';
import 'dart:async';

import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thesis_scanner/audio_manager.dart';
import 'package:thesis_scanner/consts.dart';
import 'package:thesis_scanner/data.dart';

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
    isEnabled = true;
    print('HAS PERMISSION:$isEnabled');
    if (!isEnabled) return;
    print('STARTING BEACON RANGING');

    // HERE

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
    _initLocalizationAndBeacon();
  }

  void _initLocalizationAndBeacon() async {
    await localization.init();
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
                                builder:
                                    (context) => Scaffold(
                                      appBar: AppBar(
                                        title: const Text(
                                          'Smart visit of Musée L',
                                        ),
                                        actions: <Widget>[
                                          PopupMenuButton<String>(
                                            onSelected: (String value) {
                                              if (value == 'replay') {
                                                _handleReplay(context);
                                              }
                                            },
                                            itemBuilder:
                                                (context) => const [
                                                  PopupMenuItem(
                                                    value: 'replay',
                                                    child: Text('Replay'),
                                                  ),
                                                ],
                                          ),
                                        ],
                                      ),
                                      body: const DebugPage(),
                                    ),
                              ),
                            );
                            break;
                          case 'experiment':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => Scaffold(
                                      appBar: AppBar(
                                        title: const Text(
                                          'Smart visit of Musée L',
                                        ),
                                        actions: <Widget>[
                                          PopupMenuButton<String>(
                                            onSelected: (String value) {
                                              if (value == 'replay') {
                                                _handleReplay(context);
                                              }
                                            },
                                            itemBuilder:
                                                (context) => const [
                                                  PopupMenuItem(
                                                    value: 'replay',
                                                    child: Text('Replay'),
                                                  ),
                                                ],
                                          ),
                                        ],
                                      ),
                                      body: RecordPage(
                                        record: record,
                                        setRecord: (bool r) {
                                          setState(() {
                                            record = r;
                                          });
                                        },
                                        user: user,
                                      ),
                                    ),
                              ),
                            );
                            break;
                          case 'replay':
                            _handleReplay(context);
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
                          PopupMenuItem(value: 'replay', child: Text('Replay')),
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

  void _handleReplay(BuildContext context) {
    final csv = raw_experimental_data.trim();
    final lines = LineSplitter.split(csv).toList();
    if (lines.length < 2) return;

    user.playedSections.clear();
    user.audioProgressIndex = 0;

    final dataLines = lines.sublist(1);

    DateTime? initialTime;

    for (final line in dataLines) {
      final values = line.split(',').toList();

      final time = values[2];
      final beacon1 = values[7];
      final beacon2 = values[10];
      final beacon3 = values[13];
      final beacon4 = values[16];
      final beacon5 = values[19];
      final beacon6 = values[22];

      initialTime ??= DateTime.parse(time);
      final deltaTime = DateTime.parse(time).difference(initialTime);

      Timer(deltaTime, () {
        for (final device in user.devices) {
          if (device.name == 'ESP32-1') {
            device.addEntry(int.tryParse(beacon1));
          } else if (device.name == 'ESP32-2') {
            device.addEntry(int.tryParse(beacon2));
          } else if (device.name == 'ESP32-3') {
            device.addEntry(int.tryParse(beacon3));
          } else if (device.name == 'ESP32-4') {
            device.addEntry(int.tryParse(beacon4));
          } else if (device.name == 'ESP32-5') {
            device.addEntry(int.tryParse(beacon5));
          } else if (device.name == 'ESP32-6') {
            device.addEntry(int.tryParse(beacon6));
          }
        }
        user.update();
        print(
          'Replay: $time - $beacon1 - $beacon2 - $beacon3 - $beacon4 - $beacon5 - $beacon6 - ${user.X} - ${user.Y}',
        );
      });
    }
  }
}
