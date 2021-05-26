import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfe/constants/constants.dart';
import 'package:pfe/ui/signin.dart';
import 'package:pfe/ui/signup.dart';
import 'package:pfe/ui/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "PFE",
        theme: ThemeData(primaryColor: Colors.orange[200]),
        home: SignInScreen());
  }
}
