import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'order_history_viewmodel.dart';

const Color _christmasGreen = Color(0xFF0F6B3E);
const Color _snowBackground = Color(0xFFF9F6F1);

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderHistoryViewModel = context.watch<OrderHistoryViewModel>();
    final orderHistory = orderHistoryViewModel.orderHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('주문 내역', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFFB91D2A),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, "/store");
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, "/shoppingcart");
            },
          ),
        ],
      ),
      backgroundColor: _snowBackground,
      body: orderHistory.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 140.w,
                    height: 140.w,
                    child: Image.asset("assets/ganadi1.png"),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "아직 주문 내역이 없어",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              itemCount: orderHistory.length,
              itemBuilder: (_, index) {
                final order = orderHistory[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border(
                      left: BorderSide(color: _christmasGreen, width: 4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "주문번호 #${order.orderId}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "주문시간: ${order.orderTime.toLocal()}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "합계: ${order.totalPrice}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "상태: ${order.status.name}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
