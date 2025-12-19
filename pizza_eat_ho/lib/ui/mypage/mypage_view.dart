import 'package:flutter/material.dart';

class MypageView extends StatefulWidget {
  const MypageView({super.key});

  @override
  State<MypageView> createState() => _MypageViewState();
}

class _MypageViewState extends State<MypageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("마이페이지"),
    );
  }
}
