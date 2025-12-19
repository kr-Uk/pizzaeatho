import 'package:flutter/material.dart';
import 'package:pizzaeatho/splash.dart';
import 'package:pizzaeatho/ui/home/home_view.dart';

import 'main.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/main': (context) => Main(),
        '/home': (context) => HomeView(),
      },
    );
  }
}
