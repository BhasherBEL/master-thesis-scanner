import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:thesis_scanner/device.dart';

final regions = <Region>[
  Region(identifier: 'Thesis'),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await flutterBeacon.initializeAndCheckScanning;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Device> devices = [];

  @override
  void initState() {
    super.initState();
    startBeaconRanging();
  }

  void startBeaconRanging() {
    flutterBeacon.ranging(regions).listen((RangingResult result) {
      print('Found ${result.beacons.length} beacons');
      setState(() {
        List<Device> detectedDevices = [];

        for (Beacon beacon in result.beacons) {
          Device? device = devices.firstWhereOrNull(
            (d) => d.compare(beacon),
          );

          if (device == null) {
            device = Device.createFromBeacon(beacon);
            devices.add(device);
          }

          device.addEntry(beacon.rssi);
          detectedDevices.add(device);
        }

        devices.where((d) => !detectedDevices.contains(d)).forEach((d) {
          d.addEntry(null);
        });
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
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      devices.clear();
                    });
                  },
                  child: const Text('Reset')),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  Device device = devices[index];

                  var (rssi, n, miss, distance) = device.getAverageDistance();

                  return ListTile(
                    title: Text(
                        '${device.getName()} - ${device.major}#${device.minor}'),
                    subtitle: Text(
                      '${distance?.toStringAsFixed(2)}m (${rssi.toStringAsFixed(2)}/${device.txPower})',
                    ),
                    trailing: Text(
                      '$n/${n + miss}',
                    ),
                  );
                },
              ),
            ],
          )),
    );
  }
}
