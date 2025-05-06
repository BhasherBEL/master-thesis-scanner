import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';
import 'package:thesis_scanner/device.dart';
import 'package:thesis_scanner/main.dart';
import 'package:thesis_scanner/poi.dart';
import 'package:thesis_scanner/user.dart';

final regions = <Region>[Region(identifier: 'Thesis')];
final user = User(Device.devices, POI.pois);
final localization = Localization();
