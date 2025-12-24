import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/order.dart';
import '../../util/common.dart';
import 'order_history_detail_viewmodel.dart';

class OrderHistoryDetailView extends StatelessWidget {
  const OrderHistoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrderHistoryDetailViewModel>();
    final BASE_URL = "http://${IP_PORT}/imgs/pizza/";
    final orderHistoryDetail = viewModel.orderDetails;
    final itemCount = orderHistoryDetail.length;

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
        itemCount: itemCount,
        itemBuilder: (_, index) {
          final item = orderHistoryDetail[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            padding: EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Container(
                  width: double.infinity,
                  height: 400.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                    image: DecorationImage(
                      image: NetworkImage("${BASE_URL}${item.product.image}"),
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
                Text("${item.product.name}"),
                Text("주문 가격: ${item.unitPrice}"),
                Text("상태: ${item.status}"),
                Text("크러스트: ${item.crust}"),
                Text("도우: ${item.dough}"),
                Text("토핑"),
            Wrap(
              spacing: 6,
              children: item.toppings.map((topping) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            )


            ],
            ),
          );
        },
      ),
    );
  }
}
