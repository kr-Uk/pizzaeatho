import 'dart:async';

import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/main');
    });

    return Scaffold(
      body: Center(
        child: Image.asset("assets/splash.png")
      ),
    );
  }
  
}
