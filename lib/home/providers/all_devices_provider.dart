import 'package:flutter/foundation.dart';

import '../models/light_model.dart';
import '../models/meter_info_model.dart';

class AllDevicesProvider with ChangeNotifier {
  bool isFetching = true;
  List<LightModel> _allLights = [];
  List<MeterInfoModel> _allMeters = [];

  List<LightModel> get getLights => _allLights;

  List<MeterInfoModel> get getMeters => _allMeters;

  void setupHomeDevices(List<LightModel> lights, List<MeterInfoModel> meters) {
    _allLights = lights;
    _allMeters = meters;
    toggleLoading(false);
  }

  void addMeter(MeterInfoModel meter) {
    _allMeters.add(meter);
    toggleLoading(false);
  }

  void addLight(LightModel light) {
    _allLights.add(light);
    toggleLoading(false);
  }

  toggleLoading(bool status) {
    isFetching = status;
    notifyListeners();
  }
}
