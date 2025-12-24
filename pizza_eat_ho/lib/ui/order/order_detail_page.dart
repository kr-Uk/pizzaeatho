import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_detail_view.dart';
import 'order_detail_viewmodel.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderDetailViewModel>(
        create: (_) => OrderDetailViewModel(),
        child: OrderDetailView());
  }
}