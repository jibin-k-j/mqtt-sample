
import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../models/meter_model.dart';

class MeterProvider with ChangeNotifier {
  final List<MeterModel> _allMeterReading = [];

  List<MeterModel> get getAllMeterReadings => _allMeterReading;

  set addMeterReading(MeterModel meterReading) {
    final index = _allMeterReading.indexWhere((element) => element.meterId == meterReading.meterId);
    if (index > -1) {
      _allMeterReading[index] = meterReading;
    } else {
      _allMeterReading.add(meterReading);
    }
    notifyListeners();
    log('Added meter');
  }

  void clearMeterProvider() {
    _allMeterReading.clear();
    notifyListeners();
  }
}
