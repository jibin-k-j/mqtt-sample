import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_test/util/mqtt_configuration.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final MQTTClientManager _mqttClientManager = MQTTClientManager();
  String tankReading = '';
  String todayBill = '';
  String totalBill = '';
  String voltage = '';
  String current = '';
  String unit = '';
  String button1Status = '';
  String button2Status = '';
  String button3Status = '';

  @override
  void initState() {
    setUpMqtt();
    super.initState();
  }

  setUpMqtt() async {
    await _mqttClientManager.connect();
    _mqttClientManager.subscribe('onwords/wtapkd');
    _mqttClientManager.subscribe('onwords/pkdl1');
    _mqttClientManager.subscribe('onwords/pkdl2');
    _mqttClientManager.subscribe('onwords/pkdl3');
    _mqttClientManager.subscribe('onwords/ebTotalBill');
    _mqttClientManager.subscribe('onwords/ebTodayBill');
    _mqttClientManager.subscribe('onwords/voltage');
    _mqttClientManager.subscribe('onwords/current');
    _mqttClientManager.subscribe('onwords/unit');

    setupUpdatesListener('onwords/wtapkd');
    setupUpdatesListener('onwords/pkdl1');
    setupUpdatesListener('onwords/pkdl2');
    setupUpdatesListener('onwords/pkdl3');
    setupUpdatesListener('onwords/ebTotalBill');
    setupUpdatesListener('onwords/ebTodayBill');
    setupUpdatesListener('onwords/voltage');
    setupUpdatesListener('onwords/current');
    setupUpdatesListener('onwords/unit');
  }

  void setupUpdatesListener(String topic) {
    try {
      _mqttClientManager
          .getMessagesStream()!
          .where((List<MqttReceivedMessage<MqttMessage>> messages) => messages.isNotEmpty && messages[0].topic == topic)
          .listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        final recMess = messages[0].payload as MqttPublishMessage;
        final result = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        log('SUB MESSAGE $result');

        if (!mounted) return;
        setState(() {
          switch (topic) {
            case 'onwords/wtapkd':
              tankReading = result;
              break;
            case 'onwords/pkdl1':
              button1Status = result;
              break;
            case 'onwords/pkdl2':
              button2Status = result;
              break;
            case 'onwords/pkdl3':
              button3Status = result;
              break;
            case 'onwords/ebTotalBill':
              totalBill = result;
              break;
            case 'onwords/ebTodayBill':
              todayBill = result;
              break;
            case 'onwords/voltage':
              voltage = result;
              break;
            case 'onwords/current':
              current = result;
              break;
            case 'onwords/unit':
              unit = result;
              break;
          }
          log('actual data is $result');
        });
      });
    } catch (e) {
      log('ERROR IN MQTT STREAM $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: null,
          title: const Text('MQTT'),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //tank reading
                const Text('Tank Reading', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
                Text(
                  tankReading,
                  style: const TextStyle(fontSize: 15.0),
                ),

                //ebill board
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text('Ebill Summary', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Today Bill'),
                          Text(todayBill),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Bill'),
                          Text(totalBill),
                        ],
                      )
                    ],
                  ),
                ),
                //current detail
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text('Energy Detail', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Voltage'),
                          Text(voltage),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Current'),
                          Text(current),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Unit'),
                          Text(unit),
                        ],
                      )
                    ],
                  ),
                ),

                //buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () => publishMessage('onwords/pkdl1', 'device1', true),
                        child: const Text('Button 1')),
                    ElevatedButton(
                        onPressed: () => publishMessage('onwords/pkdl2', 'device2', true),
                        child: const Text('Button 2')),
                    ElevatedButton(
                        onPressed: () => publishMessage('onwords/pkdl3', 'device3', true),
                        child: const Text('Button 3')),
                  ],
                ),
                const SizedBox(height: 10.0),
                Text('Status for Button 1 : $button1Status'),
                const SizedBox(height: 10.0),
                Text('Status for Button 2 : $button2Status'), const SizedBox(height: 10.0),
                Text('Status for Button 3 : $button3Status'),
              ],
            ),
          ),
        ));
  }

  void publishMessage(String topic, String deviceId, bool status) {
    dynamic data = jsonEncode({
      "id": deviceId,
      deviceId: status,
    });
    _mqttClientManager.publishMessage(topic, data);
  }
}
