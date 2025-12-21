import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_view.dart';
import 'order_viewmodel.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderViewModel>(
        create: (_) => OrderViewModel(),
        child: OrderView());
  }
}