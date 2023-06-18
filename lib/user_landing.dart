import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mqtt_test/home/firebase/firebase_home_operation.dart';
import 'package:mqtt_test/home/providers/all_devices_provider.dart';
import 'package:mqtt_test/home/providers/user_provider.dart';
import 'package:mqtt_test/home/view/home_view.dart';
import 'package:provider/provider.dart';

import 'auth/view/login_view.dart';

class UserLanding extends StatefulWidget {
  const UserLanding({Key? key}) : super(key: key);

  @override
  State<UserLanding> createState() => _UserLandingState();
}

class _UserLandingState extends State<UserLanding> {
  @override
  void didChangeDependencies() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.uid.isNotEmpty) {
      getDeviceInfo(userProvider.uid);
    }

    super.didChangeDependencies();
  }

  Future<void> getDeviceInfo(String userId) async {
    final deviceProvider = Provider.of<AllDevicesProvider>(context, listen: false);
    final lights = await FirebaseHomeOperation.getAllLights(userId: userId);
    final meters = await FirebaseHomeOperation.getAllMeters(userId: userId);
    log('DATA FROM FIREBASE IS $lights and $meters');
    deviceProvider.setupHomeDevices(lights, meters);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return userProvider.uid.isEmpty ? const LoginView() : const HomeView();
  }
}
