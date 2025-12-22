import 'package:flutter/material.dart';
import 'package:pizzaeatho/ui/order/order_history_viewmodel.dart';
import 'package:provider/provider.dart';

import 'order_history_view.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderHistoryViewModel>(
        create: (_) => OrderHistoryViewModel(),
        child: OrderHistoryView());
  }
}