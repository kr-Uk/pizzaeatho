import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/util/common.dart';
import 'package:provider/provider.dart';

import 'order_viewmodel.dart';

const Color _christmasGreen = Color(0xFF0F6B3E);
const Color _snowBackground = Color(0xFFF9F6F1);

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final BASE_URL = "http://${IP_PORT}/imgs/pizza/";
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrderViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('주문', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFFB91D2A),
        elevation: 0,
        scrolledUnderElevation: 0,
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
      body: _buildOrder(viewModel),
    );
  }

  Widget _buildOrder(OrderViewModel viewModel) {
    final items = viewModel.products;
    final itemCount = items.length;
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      scrollDirection: Axis.vertical,
      itemCount: itemCount,
      itemBuilder: (_, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/order_detail',
              arguments: item,
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 520.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        image: DecorationImage(
                          image: NetworkImage("${BASE_URL}${item.image}"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: textProductName),
                      const SizedBox(height: 8),
                      Text(item.description, style: textProductDescription),
                      const SizedBox(height: 6),
                      Text("${item.price}", style: textProductPrice),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
