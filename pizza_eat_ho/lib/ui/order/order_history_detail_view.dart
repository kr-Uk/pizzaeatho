import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/enums.dart';
import '../../data/model/order.dart';
import '../../util/common.dart';
import '../auth/auth_viewmodel.dart';
import 'order_history_detail_viewmodel.dart';
import 'review_form_page.dart';

class OrderHistoryDetailView extends StatelessWidget {
  const OrderHistoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrderHistoryDetailViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final baseUrl = "http://${IP_PORT}/imgs/pizza/";
    final orderHistoryDetail = viewModel.orderDetails;

    if (viewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (viewModel.errorMessage != null) {
      return Scaffold(body: Center(child: Text(viewModel.errorMessage!)));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('주문 상세')),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: orderHistoryDetail.length,
        itemBuilder: (_, index) {
          final item = orderHistoryDetail[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 400.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                    image: DecorationImage(
                      image: NetworkImage("${baseUrl}${item.product.image}"),
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
                SizedBox(height: 12.h),
                Text(item.product.name),
                Text("주문 가격 ${item.unitPrice}"),
                Text("상태: ${item.status.name}"),
                Text("크러스트: ${item.crust}"),
                Text("도우: ${item.dough}"),
                const SizedBox(height: 8),
                const Text('토핑'),
                Wrap(
                  spacing: 6,
                  children: item.toppings.map((topping) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        topping.name,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                ),
                if (item.status == OrderStatus.done)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: ElevatedButton(
                      onPressed: () {
                        final user = authViewModel.user;
                        if (user == null) {
                          Navigator.pushNamed(context, '/login');
                          return;
                        }
                        _openReviewPage(context, item, user.userId);
                      },
                      child: const Text('리뷰 작성하기'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openReviewPage(
    BuildContext context,
    OrderHistoryDetailDto item,
    int userId,
  ) {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewFormPage.create(
          userId: userId,
          options: [item],
        ),
      ),
    ).then((result) {
      if (!context.mounted || result != true) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('리뷰가 등록되었습니다.')),
      );
    });
  }
}
