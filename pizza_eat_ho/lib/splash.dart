import 'dart:async';

import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer? _timer;
  int _tapCount = 0;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      _navigate('/main');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigate(String route) {
    if (!mounted || _navigated) return;
    _navigated = true;
    Navigator.pushReplacementNamed(context, route);
  }

  void _handleTap() {
    _tapCount += 1;
    if (_tapCount >= 5) {
      _timer?.cancel();
      _navigate('/admin/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: _handleTap,
          child: SizedBox(
            child: Image.asset(
              "assets/pizza.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
