import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  @override
  Widget build(BuildContext context) {
    final event = null;
    return Scaffold(
      appBar: AppBar(
        title: Text('이벤트', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,

        // 앱 바 색이 스크롤 올라가도 안변하게 !
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,

        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {
              // 장바구니 페이지 이동
              Navigator.pushNamed(context, "/shoppingcart");
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Expanded(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 10,
          itemBuilder: (_, index) {
            return Container(
              height: 300.h,
              margin: index == 9
                  ? EdgeInsets.symmetric(vertical: 8.0)
                  : EdgeInsets.only(top: 8.0),
              child: Container(
                height: 300.w,
                color: Colors.blue,
              ),
            );
          },
        ),
      ),
    );
  }
}
