import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/ui/order/shoppingcart_viewmodel.dart';
import 'package:pizzaeatho/util/common.dart';
import 'package:provider/provider.dart';

import '../../data/model/product.dart';
import '../../data/model/shoppingcart.dart';
import 'order_detail_viewmodel.dart';

class OrderDetailView extends StatefulWidget {
  const OrderDetailView({super.key});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductDto;
    final orderDetailViewModel = context.watch<OrderDetailViewModel>();
    final shoppingcartViewModel = context.read<ShoppingcartViewModel>();

    return Scaffold(
      backgroundColor: greyBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        // 앱 바 색이 스크롤 올라가도 안변하게 !
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,

        // 뒤로가기 아이콘
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

        // 장바구니 아이콘
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              // 장바구니 페이지 이동
              Navigator.pushNamed(context, "/shoppingcart");
            },
          ),
        ],
      ),
      body: _buildOrderDetail(product, orderDetailViewModel),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: Offset(0, -2),
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("총 가격: ${orderDetailViewModel.totalPrice(product.price)}")
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final cartItem = ShoppingcartDto(
                    product: product,
                    dough: orderDetailViewModel.selectedDough!,
                    crust: orderDetailViewModel.selectedCrust!,
                    toppings: orderDetailViewModel.selectedToppings,
                    quantity: 1,
                    totalPrice: orderDetailViewModel.totalPrice(product.price),
                  );

                  shoppingcartViewModel.addItem(cartItem);

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text("장바구니 담기"),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetail(ProductDto product, OrderDetailViewModel viewModel) {
    final toppings = viewModel.toppings;
    final doughs = viewModel.doughs;
    final crusts = viewModel.crusts;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(product.image),
          Text(product.name),
          Text(product.description),
          Text("${product.price}원"),

          RadioGroup(
            groupValue: viewModel.selectedDough,
            onChanged: (value) {
              viewModel.selectDough(value!);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text("도우"),
                ...doughs.map((dough) {
                  return RadioListTile<DoughDto>(
                    value: dough,
                    title: Text(dough.name),
                    secondary: Text("+${dough.price}원"),
                  );
                }).toList(),

              ],
            ),
          ),

            RadioGroup(
              groupValue: viewModel.selectedCrust,
              onChanged: (value) {
                viewModel.selectCrust(value!);
              },
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text("크러스트"),
                ...crusts.map((crust) {
                  return RadioListTile<CrustDto>(
                    value: crust,
                    title: Text(crust.name),
                    secondary: Text("+${crust.price}원"),
                  );
                }).toList(),

              ],
                        ),
            ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text("토핑"),
              ...toppings.map((topping) {
                final isChecked =
                viewModel.selectedToppingIds.contains(topping.toppingId);

                return CheckboxListTile(
                  value: isChecked,
                  onChanged: (checked) {
                    viewModel.toggleTopping(topping.toppingId);
                  },
                  title: Text(topping.name),
                  secondary: Text("+${topping.price}원"),
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
            ],
          ),

        ],
      ),
    );
  }
}
