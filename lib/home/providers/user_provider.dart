import 'package:flutter/foundation.dart';
import 'package:mqtt_test/home/storage/user_pref.dart';

class UserProvider with ChangeNotifier {
  String _uid = '';
  String _name = '';
  String _email = '';
  String _url = '';

  UserPref userDataPreferences = UserPref();

  String get uid => _uid;

  String get name => _name;

  String get email => _email;

  String get photoUrl => _url;

  set uid(String uid) {
    _uid = uid;
    userDataPreferences.storeUid(uid);
    notifyListeners();
  }

  set email(String email) {
    _email = email;
    userDataPreferences.storeEmail(email);
    notifyListeners();
  }

  set name(String name) {
    _name = name;
    userDataPreferences.storeName(name);
    notifyListeners();
  }

  set url(String url) {
    _url = url;
    userDataPreferences.storeUrl(url);
    notifyListeners();
  }

  Future<void> clearUserProvider() async {
    _uid = '';
    _name = '';
    _email = '';
    _url = '';

    await userDataPreferences.deleteStorage();
    notifyListeners();
  }
}
