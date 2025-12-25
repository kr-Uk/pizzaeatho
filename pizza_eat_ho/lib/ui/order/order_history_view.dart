import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/order.dart';
import '../../util/common.dart';
import '../auth/auth_viewmodel.dart';
import 'order_history_detail_page.dart';
import 'order_history_viewmodel.dart';
import 'review_form_page.dart';

const Color _christmasGreen = Color(0xFF0F6B3E);
const Color _snowBackground = Color(0xFFF9F6F1);

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderHistoryViewModel = context.watch<OrderHistoryViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final isLoading = orderHistoryViewModel.isLoading;
    final baseUrl = "http://${IP_PORT}/imgs/pizza/";

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
                    '로그인이 필요합니다.',
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    child: const Text('로그인'),
                  ),
                ],
              ),
            )
          : isLoading
              ? const Center(child: CircularProgressIndicator())
              : DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Container(
                        color: const Color(0xFFB91D2A),
                        child: const TabBar(
                          labelColor: Colors.white,
                          indicatorColor: Colors.white,
                          tabs: [
                            Tab(text: '주문 현황'),
                            Tab(text: '주문 완료'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildOrderList(
                              context,
                              orderHistoryViewModel,
                              authViewModel,
                              orderHistoryViewModel.activeOrders,
                              baseUrl,
                              emptyMessage: '진행 중인 주문이 없습니다.',
                            ),
                            _buildOrderList(
                              context,
                              orderHistoryViewModel,
                              authViewModel,
                              orderHistoryViewModel.doneOrders,
                              baseUrl,
                              emptyMessage: '완료된 주문이 없습니다.',
                              showReviewButton: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildOrderList(
    BuildContext context,
    OrderHistoryViewModel viewModel,
    AuthViewModel authViewModel,
    List<OrderHistoryDto> orders,
    String baseUrl, {
    required String emptyMessage,
    bool showReviewButton = false,
  }) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      itemCount: orders.length,
      itemBuilder: (_, index) {
        final order = orders[index];
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
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          OrderHistoryDetailPage(orderId: order.orderId),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 600.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
                        image: DecorationImage(
                          image: NetworkImage(
                            "${baseUrl}${order.products[0].image}",
                          ),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '주문 #${order.orderId}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
              ),
              if (showReviewButton)
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        final user = authViewModel.user;
                        if (user == null) {
                          Navigator.pushNamed(context, '/login');
                          return;
                        }

                        final details =
                            await viewModel.fetchOrderDetails(order.orderId);

                        if (!context.mounted) return;

                        if (details.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('주문 상세를 불러오지 못했습니다.'),
                            ),
                          );
                          return;
                        }

                        final result = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReviewFormPage.create(
                              userId: user.userId,
                              options: details,
                            ),
                          ),
                        );
                        if (!context.mounted || result != true) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('리뷰가 등록되었습니다.')),
                        );
                      },
                      child: const Text('리뷰 작성하기'),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

}
