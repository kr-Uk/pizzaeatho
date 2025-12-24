import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../auth/auth_viewmodel.dart';
import 'order_history_viewmodel.dart';

const Color _christmasGreen = Color(0xFF0F6B3E);
const Color _snowBackground = Color(0xFFF9F6F1);

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderHistoryViewModel = context.watch<OrderHistoryViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final orderHistory = orderHistoryViewModel.orderHistory;
    final isLoading = orderHistoryViewModel.isLoading;

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
      body: !authViewModel.isLoggedIn
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '로그인이 필요한 서비스입니다.',
                    style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCE1933),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    child: const Text('로그인 하기'),
                  ),
                ],
              ),
            )
          : isLoading
              ? const Center(child: CircularProgressIndicator())
              : orderHistory.isEmpty
              ? Center(
                  child: Text(
                    '아직 주문 내역이 없어요.',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
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
                            '주문번호 #${order.orderId}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '주문시간: ${order.orderTime.toLocal()}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '총액: ${order.totalPrice}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '상태: ${order.status.name}',
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
