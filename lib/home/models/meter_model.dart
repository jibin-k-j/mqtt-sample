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
  });

  // factory MeterModel.fromJson(Map<String, dynamic> json) => MeterModel(
  //   meterId: json["voltage 1"]?.toDouble(),
  //       voltage1: json["voltage 1"]?.toDouble(),
  //       voltage2: json["voltage 2"]?.toDouble(),
  //       voltage3: json["voltage 3"]?.toDouble(),
  //       current1: json["current 1"]?.toDouble(),
  //       current2: json["current 2"]?.toDouble(),
  //       current3: json["current 3"]?.toDouble(),
  //       vAvg: json["Volts ave"]?.toDouble(),
  //       vSum: json["Volts Sum"]?.toDouble(),
  //       aAvg: json["Current Ave"]?.toDouble(),
  //       aSum: json["Current Sum"]?.toDouble(),
  //       wAvg: json["Watts Ave"]?.toDouble(),
  //       wSum: json["Watts Sum"]?.toDouble(),
  //     );
  //
  // Map<String, dynamic> toJson() => {
  //       "voltage 1": voltage1,
  //       "voltage 2": voltage2,
  //       "voltage 3": voltage3,
  //       "current 1": current1,
  //       "current 2": current2,
  //       "current 3": current3,
  //       "Volts ave": vAvg,
  //       "Volts Sum": vSum,
  //       "Current Ave": aAvg,
  //       "Current Sum": aSum,
  //       "Watts Sum": wSum,
  //       "Watts Ave": wAvg,
  //     };
}
