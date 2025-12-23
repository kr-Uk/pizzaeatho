import 'dart:async';

import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/main');
    });

    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          "assets/pizza.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
