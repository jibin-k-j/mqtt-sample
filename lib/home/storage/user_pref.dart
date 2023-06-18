import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/light_model.dart';
import '../models/meter_info_model.dart';

class UserPref {
  final String _uid = 'USER_UID';
  final String _email = "USER_EMAIL";
  final String _name = "USER_NAME";
  final String _url = "USER_URL";

  storeUid(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_uid, uid);
  }

  Future<String> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_uid) ?? '';
  }

  storeName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_name, name);
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_name) ?? '';
  }

  storeEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_email, email);
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_email) ?? '';
  }

  storeUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_url, url);
  }

  Future<String> getUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_url) ?? '';
  }

  Future<void> deleteStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_uid);
    await prefs.remove(_name);
    await prefs.remove(_email);
    await prefs.remove(_url);
  }
}
