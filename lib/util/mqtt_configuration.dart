import 'dart:developer';
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTClientManager {
  MqttServerClient client =
  MqttServerClient.withPort('mqtt.onwordsapi.com', DateTime.now().millisecondsSinceEpoch.toString(), 1883);

  Future<int> connect() async {
    client.logging(on: false);
    client.keepAlivePeriod = 60;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    final connMessage =
    MqttConnectMessage().startClean().withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      log('MQTTClient::Client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      log('MQTTClient::Socket exception - $e');
      client.disconnect();
    }

    return 0;
  }

  void disconnect() {
    client.disconnect();
  }

  void subscribe(String topic) {
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      client.subscribe(topic, MqttQos.atLeastOnce);
    }
  }

  void onConnected() {
    log('MQTTClient::Connected');
  }

  void onDisconnected() {
    log('MQTTClient::Disconnected');
  }

  void onSubscribed(String topic) {
    log('MQTTClient::Subscribed to topic: $topic');
  }

  void pong() {
    log('MQTTClient::Ping response received');
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    log('MQTT START TO PUBLISH MESSAGE');
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      log('MQTT PUBLISHED MESSAGE TO $topic');
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    }
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    return client.updates;
  }



}
