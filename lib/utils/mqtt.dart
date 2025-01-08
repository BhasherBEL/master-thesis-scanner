import 'dart:convert';
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:logging/logging.dart';
import 'package:thesis_scanner/device.dart';
import 'package:thesis_scanner/secrets.dart';

final _log = Logger("MQTT");

MqttServerClient? client;

Future<void> mqttConnect(String udid) async {
  client = MqttServerClient.withPort(mqttServer, mqttClientName, mqttPort);
  client?.keepAlivePeriod = 60;
  final connMessage = MqttConnectMessage()
      .authenticateAs(mqttUser, mqttPassword)
      .withWillTopic('users/scanner/$udid/status')
      .withWillMessage(
          '{"status": "offline", "timestamp": ${DateTime.now().millisecondsSinceEpoch}}')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);
  client?.connectionMessage = connMessage;

  client?.secure = true;
  client?.securityContext = SecurityContext.defaultContext;

  try {
    _log.info('Attempting to connect to MQTT broker...');
    await client?.connect();
  } catch (e) {
    _log.severe('Failed to connect to MQTT broker', e);
    client?.disconnect();
    return;
  }

  _log.info('Successfully connected to MQTT broker');

  client?.subscribe("ibeacon/devices/#", MqttQos.atLeastOnce);

  client?.updates?.listen(mqttListener);
}

void mqttListener(List<MqttReceivedMessage<MqttMessage?>>? c) {
  if (c == null) return;
  final topic = c[0].topic;
  final recMessage = c[0].payload as MqttPublishMessage;
  final payload =
      MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

  if (topic.startsWith('ibeacon/devices/')) {
    final deviceId = topic.split('/')[2];
    storeDeviceData(deviceId, payload);
  }
}

void storeDeviceData(String deviceId, String data) {
  try {
    Map<String, dynamic> jsonData = jsonDecode(data);
    final name = jsonData['name'];
    final uuid = jsonData['uuid'];
    final major = jsonData['major']?.toInt() ?? 0;
    final minor = jsonData['minor']?.toInt() ?? 0;
    final txPower = jsonData['txPower']?.toInt() ?? 0;
    final X = jsonData['X']?.toDouble() ?? 0.0;
    final Y = jsonData['Y']?.toDouble() ?? 0.0;
    final am = jsonData['am']?.toDouble() ?? 0.0;

    Device d = Device(name, uuid, major, minor, txPower, X, Y, am);
    Device.addOrUpdateDevice(d);
  } catch (e, stackTrace) {
    _log.severe('Failed to parse JSON data: $data', e, stackTrace);
    return;
  }
}
