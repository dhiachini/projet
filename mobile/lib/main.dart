import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfe/ui/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  get prefixIcon => null;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "OVictoire",
        theme: ThemeData(primaryColor: Colors.orange[900]),
        home: SplashScreen());
  }
}
