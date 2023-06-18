import 'package:flutter/foundation.dart';

class LoginViewModel with ChangeNotifier {
  bool isLoading = false;
  bool isVisible = false;

  //Changing loading status;
  void toggleLoading(bool status) {
    isLoading = status;
    notifyListeners();
  }

  //Changing visible status;
  void toggleVisibility(bool status) {
    isVisible = status;
    notifyListeners();
  }
}
