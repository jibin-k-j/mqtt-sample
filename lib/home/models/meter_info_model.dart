import 'package:mqtt_test/home/models/meter_model.dart';

class MeterInfoModel {
  String name;
  String meterId;

  MeterInfoModel({
    required this.name,
    required this.meterId,
  });

  factory MeterInfoModel.fromJson(Map<String, dynamic> json) => MeterInfoModel(
        name: json["name"],
        meterId: json["meterId"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "meterData": meterId,
      };
}
