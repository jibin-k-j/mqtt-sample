import 'dart:convert';
import 'dart:developer';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_test/home/models/meter_model.dart';
import 'package:mqtt_test/home/providers/light_provider.dart';
import 'package:mqtt_test/util/mqtt_configuration.dart';
import '../providers/meter_provider.dart';

class HomeViewModel {
  final MQTTClientManager _mqttClientManager = MQTTClientManager();

//MQTT TOPICS
  String meterTopic = 'onwords/energymeterpkd001';

  MQTTClientManager get getMqttManager => _mqttClientManager;

  void initializeMQTT() async {
    await _mqttClientManager.connect();
  }

  void setupMeterMQTT(MeterProvider meterProvider) {
    _mqttClientManager.subscribe(meterTopic);
    setupUpdatesListener(meterTopic, meterProvider);
  }

  void setupLightMQTT(String topic, LightProvider lightProvider) {
    _mqttClientManager.subscribe(topic);
    setupUpdatesListener(topic, lightProvider);
  }

  void sendLightMQTTRequest(String topic) {
    final data = jsonEncode({"request": "getCurrentStatus"});
    _mqttClientManager.publishMessage(topic, data);
  }

  //CHECKING FOR MQTT CONNECTION STATUS
  bool isMQTTActive() => _mqttClientManager.checkMqttConnection();

  //STREAM LISTENER FOR MQTT
  void setupUpdatesListener(String topic, dynamic provider) {
    try {
      _mqttClientManager
          .getMessagesStream()!
          .where((List<MqttReceivedMessage<MqttMessage>> messages) => messages.isNotEmpty && messages[0].topic == topic)
          .listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        final recMess = messages[0].payload as MqttPublishMessage;
        final result = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        final jsonData = json.decode(result);

        //for meter
        if (topic == meterTopic) {
          if (jsonData['data']['modbus'].first['voltage 1'].toString() != 'null') {
            // log('SUB MESSAGE JSON ${jsonData['data']['modbus'].first['voltage 1']}');
            final data = MeterModel(
                meterId: jsonData['data']['modbus'].first['sid'].toString(),
                voltage1: jsonData['data']['modbus'].first['voltage 1'],
                voltage2: jsonData['data']['modbus'].first['voltage 2'],
                voltage3: jsonData['data']['modbus'].first['voltage 3'],
                current1: jsonData['data']['modbus'].first['current 1'],
                current2: jsonData['data']['modbus'].first['current 2'],
                current3: jsonData['data']['modbus'].first['current 3'],
                vAvg: jsonData['data']['modbus'].first['Volts ave'],
                vSum: jsonData['data']['modbus'].first['Volts Sum'],
                aAvg: jsonData['data']['modbus'].first['Current Ave'],
                aSum: jsonData['data']['modbus'].first['Current Sum'],
                wAvg: jsonData['data']['modbus'].first['Watts Ave'],
                wSum: jsonData['data']['modbus'].first['Watts Sum'],
                wh: jsonData['data']['modbus'].first['WH Import']);
            provider.addMeterReading = data;
          }
        } else {
          //for light
          provider.setResponse = result;
        }
      });
    } catch (e) {
      log('ERROR IN MQTT STREAM $e');
    }
  }

  //CLEARING MQTT MANAGER
  void clearMQTT() => _mqttClientManager.disconnect();
}
