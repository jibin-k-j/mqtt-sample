import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_test/home/providers/meter_provider.dart';
import 'package:mqtt_test/home/view/home_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    return runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MeterProvider()),
      ],
      child: MaterialApp(
        title: 'Smart Dashboard',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const HomeView(),
      ),
    );
  }
}
