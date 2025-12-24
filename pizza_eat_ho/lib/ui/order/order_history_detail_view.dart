import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/model/order.dart';
import '../../util/common.dart';
import 'order_history_detail_viewmodel.dart';

class OrderHistoryDetailView extends StatelessWidget {
  const OrderHistoryDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrderHistoryDetailViewModel>();

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(vm.errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('주문 상세')),
      body: ListView.builder(
        itemCount: vm.orderDetails.length,
        itemBuilder: (context, index) {
          final item = vm.orderDetails[index];
          return ListTile(
            title: Text(item.product.name),
            subtitle: Text(
              '${item.dough} / ${item.crust}',
            ),
            trailing: Text('${item.unitPrice}원'),
          );
        },
      ),
    );
  }

}