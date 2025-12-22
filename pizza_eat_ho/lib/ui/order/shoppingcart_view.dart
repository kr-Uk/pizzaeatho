import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/ui/order/shoppingcart_viewmodel.dart';
import 'package:provider/provider.dart';

class ShoppingcartView extends StatefulWidget {
  const ShoppingcartView({super.key});

  @override
  State<ShoppingcartView> createState() => _ShoppingcartViewState();
}

class _ShoppingcartViewState extends State<ShoppingcartView> {

  @override
  Widget build(BuildContext context) {
    final shoppingcartViewModel = context.watch<ShoppingcartViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('장바구니', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildShoppingcart(shoppingcartViewModel)
    );
  }

  Widget _buildShoppingcart(ShoppingcartViewModel shoppingcartViewModel) {
    final items = shoppingcartViewModel.items;
    final itemCount = items.length;
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: itemCount,
      itemBuilder: (_, index) {
        final item = items[index];
        return Container(
          height: 800.h,
          color: Colors.grey,
          margin: index == itemCount-1
              ? EdgeInsets.symmetric(vertical: 8.0)
              : EdgeInsets.only(top: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Container(
                  height: 300.h,
                  decoration: BoxDecoration(
                      borderRadius: .circular(30.r),
                      color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage(item.product.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text("도우 : ${item.dough.name}"),
                Text("크러스트 : ${item.crust.name}"),
                Row(
                  children: [
                    Text("토핑 : "),
                    Text(
                      item.toppings.map((t) => "${t.name} ").join()
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => shoppingcartViewModel.removeItem(index),
                  icon: Icon(Icons.delete_outline, color: Colors.white),
                )

              ],
            ),
          ),
        );
      },
    );
  }
}
