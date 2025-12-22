import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'order_history_viewmodel.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderHistoryViewModel = context.watch<OrderHistoryViewModel>();
    final orderHistory = orderHistoryViewModel.orderHistory;

    return Scaffold(
      appBar: AppBar(
        title: Text('주문내역', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, "/shoppingcart");
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: orderHistory.isEmpty
          ? Center(
        child: Text(
          "주문 내역이 없습니다.",
          style: TextStyle(fontSize: 20.sp, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        itemCount: orderHistory.length,
        itemBuilder: (_, index) {
          final order = orderHistory[index];
          return Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "주문 번호: ${order.orderId}",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "주문 시간: ${order.orderTime.toLocal()}",
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  "총 금액: ${order.totalPrice}원",
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  "상태: ${order.status.name}",
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
