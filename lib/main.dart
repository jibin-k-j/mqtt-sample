import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_test/auth/view_model/login_view_model.dart';
import 'package:mqtt_test/home/providers/all_devices_provider.dart';
import 'package:mqtt_test/home/providers/light_provider.dart';
import 'package:mqtt_test/home/providers/meter_provider.dart';
import 'package:mqtt_test/home/view/home_view.dart';
import 'package:mqtt_test/user_landing.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'home/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    return runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserProvider userProvider = UserProvider();

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  //USER DATA
  void getUserData() async {
    userProvider.uid = await userProvider.userDataPreferences.getUid();

    userProvider.email = await userProvider.userDataPreferences.getEmail();

    userProvider.name = await userProvider.userDataPreferences.getName();

    userProvider.url = await userProvider.userDataPreferences.getUrl();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MeterProvider()),
        ChangeNotifierProvider(create: (_) => LightProvider()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => AllDevicesProvider()),

        ChangeNotifierProvider(create: (_) => userProvider),
      ],
      child: MaterialApp(
        title: 'Smart Dashboard',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: const UserLanding(),
      ),
    );
  }
}
