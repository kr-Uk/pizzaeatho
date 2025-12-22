import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주문내역', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
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
              height: 700.h,
              color: Colors.grey,
              margin: index == 9
                  ? EdgeInsets.symmetric(vertical: 8.0)
                  : EdgeInsets.only(top: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      height: 300.h,
                      decoration: BoxDecoration(
                          borderRadius: .circular(30.r),
                          color: Colors.white
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text("준규킹", style: TextStyle(color: Colors.white)),
                    Text("준규킹", style: TextStyle(color: Colors.white)),
                    Text("준규킹", style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
