import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'order_viewmodel.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrderViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('주문하기', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,

        // 앱 바 색이 스크롤 올라가도 안변하게 !
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,

        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {
              // 장바구니 페이지 이동
              Navigator.pushNamed(context, "/shoppingcart");

            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _buildOrder(viewModel)
    );
  }

  Widget _buildOrder(OrderViewModel viewModel) {
    final items = viewModel.products;     // viewModel에 저장된 items
    final itemCount = items.length;
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: itemCount,
        itemBuilder: (_, index) {
          final item = items[index];
          return Container(
            height: 1000.h,
            color: Colors.green,
            margin: index == itemCount-1
                ? EdgeInsets.symmetric(vertical: 8.0)
                : EdgeInsets.only(top: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    height: 500.h,
                    decoration: BoxDecoration(
                        borderRadius: .circular(30.r),
                        color: Colors.white
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(item.productId.toString(), style: TextStyle(color: Colors.white)),
                  Text(item.name, style: TextStyle(color: Colors.white)),
                  Text(item.basePrice.toString(), style: TextStyle(color: Colors.white))
                ],
              ),
            ),
          );
        },
    );
  }
}
