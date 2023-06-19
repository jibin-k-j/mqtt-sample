class MeterModel {
  String meterId;
  double voltage1;
  double voltage2;
  double voltage3;
  double current1;
  double current2;
  double current3;
  double vAvg;
  double vSum;
  double aAvg;
  double aSum;
  double wAvg;
  double wSum;
  double wh;

  MeterModel({
    required this.meterId,
    required this.voltage1,
    required this.voltage2,
    required this.voltage3,
    required this.current1,
    required this.current2,
    required this.current3,
    required this.vAvg,
    required this.vSum,
    required this.aAvg,
    required this.aSum,
    required this.wAvg,
    required this.wSum,
    required this.wh,
  });

  factory MeterModel.fromJson(Map<String, dynamic> json) => MeterModel(
        meterId: json["meterId"],
        voltage1: json["voltage1"]?.toDouble(),
        voltage2: json["voltage2"]?.toDouble(),
        voltage3: json["voltage3"]?.toDouble(),
        current1: json["current1"]?.toDouble(),
        current2: json["current2"]?.toDouble(),
        current3: json["current3"]?.toDouble(),
        vAvg: json["vAvg"]?.toDouble(),
        vSum: json["vSum"]?.toDouble(),
        aAvg: json["aAvg"]?.toDouble(),
        aSum: json["aSum"]?.toDouble(),
        wAvg: json["wAvg"]?.toDouble(),
        wSum: json["wSum"]?.toDouble(),
        wh: json["wh"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'meterId': meterId,
        "voltage1": voltage1,
        "voltage2": voltage2,
        "voltage3": voltage3,
        "current1": current1,
        "current2": current2,
        "current3": current3,
        "vAvg": vAvg,
        "vSum": vSum,
        "aAvg": aAvg,
        "aSum": aSum,
        "wSum": wSum,
        "wAvg": wAvg,
        "wh": wh,
      };
}
