import 'package:flutter/material.dart';
import 'package:pizzaeatho/ui/admin/admin_orders_view.dart';
import 'package:pizzaeatho/ui/admin/admin_orders_viewmodel.dart';
import 'package:provider/provider.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminOrdersViewModel(),
      child: const AdminOrdersView(),
    );
  }
}
