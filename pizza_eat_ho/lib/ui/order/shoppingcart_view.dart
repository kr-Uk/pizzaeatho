import 'package:flutter/material.dart';

class ShoppingcartView extends StatefulWidget {
  const ShoppingcartView({super.key});

  @override
  State<ShoppingcartView> createState() => _ShoppingcartViewState();
}

class _ShoppingcartViewState extends State<ShoppingcartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("쇼핑카트"),
    );
  }
}
