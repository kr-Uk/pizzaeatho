import 'package:flutter/material.dart';
import 'package:pizzaeatho/data/model/product.dart';
import 'package:provider/provider.dart';

import 'order_detail_view.dart';
import 'order_detail_viewmodel.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductDto;

    return ChangeNotifierProvider<OrderDetailViewModel>(
        create: (_) => OrderDetailViewModel(product.productId),
        child: OrderDetailView());
  }
}