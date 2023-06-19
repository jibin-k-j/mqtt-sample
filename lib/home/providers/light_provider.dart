import 'dart:developer';
import 'package:flutter/foundation.dart';

class LightProvider with ChangeNotifier {
  String _response = '';

  String get getResponse => _response;

  set setResponse(String response) {
    log('Added light');
    _response = response;
    notifyListeners();
  }
}
