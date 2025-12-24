import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_history_detail_view.dart';
import 'order_history_detail_viewmodel.dart';

class OrderHistoryDetailPage extends StatelessWidget {
  final int orderId;

  const OrderHistoryDetailPage({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderHistoryDetailViewModel>(
      create: (_) => OrderHistoryDetailViewModel(orderId),
      child: const OrderHistoryDetailView(),
    );
  }
}
