import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/util/common.dart';
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
      backgroundColor: greyBackground,
      body: _buildOrder(viewModel)
    );
  }

  Widget _buildOrder(OrderViewModel viewModel) {
    final items = viewModel.products;
    final itemCount = items.length;
    return ListView.builder(
      physics: BouncingScrollPhysics(),
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
              height: 1000.h,
              color: Colors.white,
              margin: index == itemCount - 1
                  ? EdgeInsets.symmetric(vertical: 8.0)
                  : EdgeInsets.only(bottom: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 500.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        image: DecorationImage(
                          image: AssetImage(item.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Text(item.name, style: textProductName),
                    Text(item.description, style: textProductDescription),
                    Text("${item.price}원", style: textProductPrice),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }
}
